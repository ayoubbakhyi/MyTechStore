# Kubernetes — Storage (PV/PVC) & Probes — Learning Journal

> DevOps learning journey, Phase 5: closing the data-persistence loop from
> Phase 4, plus liveness/readiness probes for real health detection.
> Background: Sysadmin/IT, learning hands-on via projects.
> Follows Phase 4: kubernetes-fundamentals-journal.md

**Cluster:** same self-managed 2-node kubeadm cluster (`cluster-master` /
`cluster-worker`) on Google Cloud VMs, same MyTechStore project.

---

## Part 1 — PersistentVolume / PersistentVolumeClaim

**Goal:** stop losing MySQL data on every Pod restart/recreation — direct
Kubernetes equivalent of the Docker named-volume lesson from Phase 1.
This closes an explicitly flagged open loop from Phase 4.

### Concept mapping (Docker → Kubernetes)

| Docker | Kubernetes |
|---|---|
| `docker volume create pg-data` | **PersistentVolume (PV)** — the actual storage resource |
| `-v pg-data:/var/lib/postgresql/data` | **PersistentVolumeClaim (PVC)** — a Pod's request for storage |
| Volume survives container removal | PV/PVC survive Pod deletion/rescheduling |

The PV/PVC split exists so app manifests can request storage generically
without knowing exactly how/where it's provisioned — same spirit as Services
decoupling app code from real Pod IPs.

### Setup used: `hostPath` (appropriate for this cluster, not for real production)

No dynamic storage provisioner exists on a self-managed kubeadm cluster, so
storage was tied to a specific node's local disk via `hostPath`, with the
Pod explicitly pinned to that same node via `nodeSelector`. **Known
limitation:** if the Pod is ever scheduled to a different node, it won't see
this data. Real production clusters solve this with network-attached
storage (NFS) or cloud-managed dynamic provisioning — noted as a
known simplification for learning purposes, not a production pattern.

### Manifests

**PersistentVolume:**
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data/mysql
  persistentVolumeReclaimPolicy: Retain
```

**PersistentVolumeClaim:**
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
```

**MySQL Deployment (replacing the old bare Pod), pinned to the node holding
the hostPath data, mounting the PVC:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      nodeSelector:
        kubernetes.io/hostname: cluster-worker
      containers:
        - name: mysql
          image: mysql:8
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_DATABASE
              value: mytechstore
            - name: MYSQL_ROOT_PASSWORD
              value: rootpass
          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-storage
          persistentVolumeClaim:
            claimName: mysql-pvc
```

Existing `mysql-service` (from Phase 4) picked up these new Pods
automatically via its existing `selector: app: mysql` — no changes needed.

### What broke / mistakes

1. **New PVC stuck in `Pending`** — turned out `mysql-pv` was already
   `Bound` to an unrelated leftover PVC (`dynamic-test`) from an earlier,
   unrelated practice session. A `ReadWriteOnce` PV can only bind to one
   PVC at a time.
   **Fix:** confirmed nothing depended on the old claim, then
   `kubectl delete pvc dynamic-test`.

2. **PV stuck in `Released`, not `Available`, even after deleting the old
   claim** — this is a real, non-obvious Kubernetes behavior, not a bug:
   with `persistentVolumeReclaimPolicy: Retain`, a PV does **not**
   automatically become reusable after its claim is deleted. It intentionally
   requires manual confirmation, since `Retain` exists specifically to
   prevent silent data loss/reuse.
   **Fix:**
   ```bash
   kubectl patch pv mysql-pv -p '{"spec":{"claimRef": null}}'
   ```
   This manually clears the stale claim reference, allowing the PV to
   become `Available` again and bind to the new `mysql-pvc`.

### Verified result — persistence proven end-to-end

```bash
# Before deleting the Pod
kubectl exec -it <mysql-pod> -- mysql -uroot -prootpass mytechstore -e "SELECT COUNT(*) FROM produit;"
# → 18

kubectl delete pod <mysql-pod>
# Deployment automatically recreates it (ReplicaSet reconciliation, from Phase 4)

# After the new Pod is Running
kubectl exec -it <new-mysql-pod> -- mysql -uroot -prootpass mytechstore -e "SELECT COUNT(*) FROM produit;"
# → 18 (identical, no re-seeding required)
```

### Key takeaway

`Retain` reclaim policy trades convenience for safety: cleanup after
deleting a PVC is a deliberate, manual step (clearing `claimRef`), not
automatic — the opposite of what might be assumed coming from Docker's
simpler volume model. This is the correct default for anything holding real
data you don't want silently wiped or reused.

---

## Part 2 — Liveness & Readiness Probes

**Goal:** teach Kubernetes to detect an app that's technically running but
actually broken or not yet ready — something a plain "is the process alive"
check can't catch.

### The two probe types

- **Liveness probe** — "should this container be restarted?" Repeated
  failures → Kubernetes kills and restarts the container. For detecting
  hangs/deadlocks.
- **Readiness probe** — "should this container receive traffic right now?"
  Repeated failures → Pod is removed from the Service's endpoints (traffic
  stops routing to it), but the container is **not** restarted. For
  temporary not-ready states (startup, overload) where killing the
  container would be the wrong response.

### Manifest (MyTechStore Deployment, HTTP-based probes against Tomcat)

```yaml
          readinessProbe:
            httpGet:
              path: /
              port: 8080
            initialDelaySeconds: 15
            periodSeconds: 10
            timeoutSeconds: 3
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /
              port: 8080
            initialDelaySeconds: 45
            periodSeconds: 20
            timeoutSeconds: 3
            failureThreshold: 3
```

### Test 1 — intentional readiness failure (prove Service isolation works)

Temporarily pointed the readiness probe at a nonexistent path
(`/this-path-does-not-exist`). Result:
- `kubectl get pods` → `READY: 0/1`, but `STATUS` stayed `Running`,
  `RESTARTS` stayed `0` — confirming readiness failure does **not** restart
  the container, only marks it not-ready.
- `kubectl get endpoints mytechstore-service` → the failing Pod's IP was
  removed from the list, proving the Service genuinely stopped routing
  traffic to it.
- `kubectl describe pod` showed `Readiness probe failed: HTTP probe failed
  with statuscode: 404` — exactly matching the intentionally broken path.

### Test 2 — unexpected liveness warnings (real cold-start debugging)

While the readiness test above was running, **liveness probes also failed
twice**, early in the Pod's life — but with a different error:
```
Liveness probe failed: Get "http://<pod-ip>:8080/": context deadline
exceeded (Client.Timeout exceeded while awaiting headers)
```
This was a timeout, not a 404 — a different failure mode than the
intentional readiness break, worth investigating separately rather than
assuming it was the same root cause.

**Investigation:**
```bash
kubectl exec -it <pod> -- curl -w "\nTime: %{time_total}s\n" -o /dev/null -s http://localhost:8080/
# → 0.0027s
```
Response time in steady state was extremely fast (2.7ms) — ruling out "the
app is just slow" as an explanation. Combined with the fact that liveness
**stopped failing after the first ~60 seconds** (while the deliberately
broken readiness probe kept failing continuously the whole time), the
conclusion: this was a **JVM cold-start timing issue**, not a persistent
problem. The very first requests after Tomcat/JVM startup can occasionally
exceed a tight `timeout=1s`, even though steady-state performance is fine.

**Fix applied** — added headroom rather than assuming a code-level issue:
```yaml
          livenessProbe:
            ...
            initialDelaySeconds: 45   # was 30 — more time for JVM warm-up before first check
            timeoutSeconds: 3         # was implicit default of 1s — cushion for cold-start variability
```

### What broke / mistakes (a genuinely useful non-Kubernetes lesson)

- **A YAML edit that was discussed but never actually saved to the file**
  caused real confusion — `kubectl apply` kept "succeeding" but the running
  Pod still showed the old, broken readiness path. Diagnosed by directly
  `cat`-ing the file, which revealed the edit had simply never been made.
  **Lesson:** when a fix doesn't seem to take effect after `kubectl apply`,
  verify the actual file contents (`cat <file>.yaml`) before assuming the
  cluster itself is behaving unexpectedly — the simplest explanation
  (edit didn't save) is often the real one.
- Related: `kubectl rollout status deployment/<name>` is a more reliable
  way to confirm a rollout genuinely completed, versus just eyeballing
  `kubectl get pods` timing.

### Verified result

After correcting the file and reapplying:
```bash
kubectl describe pod <pod>
# Ready: True
# Readiness: http-get http://:8080/ ... (correct path)
# Liveness: http-get http://:8080/ delay=45s timeout=3s ...
# No new Unhealthy events after startup
```

### Key takeaways

- Readiness and liveness probes fail independently and mean different
  things — a 404 (readiness, intentional in this case) and a timeout
  (liveness, cold-start) are separate signals requiring separate diagnosis,
  not automatically the same root cause just because they happened around
  the same time.
- JVM-based applications often need more forgiving `initialDelaySeconds`
  and/or `timeoutSeconds` than the tight Kubernetes defaults, specifically
  to absorb cold-start variability — not because the app is actually slow
  in steady state.
- Distinguishing "recovered on its own after a few failures" from "actively,
  persistently failing" is a key diagnostic skill — the former points to
  timing/tuning, the latter points to an actual bug.
- Always verify a config file's actual on-disk contents before trusting
  that an intended edit was applied — a very human, very common source of
  "the cluster isn't doing what I told it to" confusion.

---

## Next Up

- **Resources (requests/limits)** — the third topic from this study session,
  not yet done hands-on.
- Portfolio/CV checkpoint (flagged as a good moment to package what's been
  built so far: Docker, CI/CD across two platforms, and now a genuinely
  production-shaped Kubernetes deployment with persistent storage and health
  probes).
- Terraform, monitoring (Prometheus/Grafana) — remain on the longer-term
  roadmap.
