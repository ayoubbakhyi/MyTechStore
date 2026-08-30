# Kubernetes — Config, Secrets, Resources & StatefulSets — Learning Journal

> DevOps learning journey, Phase 6: externalizing configuration properly,
> resource governance, and converting MySQL to its architecturally correct
> workload type.
> Background: Sysadmin/IT, learning hands-on via projects.
> Follows Phase 5: kubernetes-storage-probes-journal.md

**Cluster:** same self-managed 2-node kubeadm cluster (`cluster-master` /
`cluster-worker`) on Google Cloud VMs, same MyTechStore project.

---

## Part 1 — ConfigMaps & Secrets

**Goal:** stop hardcoding config (especially `DB_PASSWORD`) directly in
Deployment YAML files that could end up committed to Git.

### The split
- **ConfigMap** — non-sensitive config (`DB_HOST`, `DB_NAME`, `DB_USER`) —
  plain text, safe to commit
- **Secret** — sensitive values (`DB_PASSWORD`) — base64-**encoded**, not
  encrypted. Real protection comes from RBAC (who can read Secrets — not
  yet covered) and, in production, tools like Sealed Secrets or a cloud KMS.
  The immediate, real win here is simply: sensitive values no longer sit in
  plaintext inside Deployment manifests.

### Manifests

**ConfigMap:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: mytechstore-config
data:
  DB_HOST: mysql-service
  DB_NAME: mytechstore
  DB_USER: root
```

**Secret** (created imperatively, avoids manual base64 encoding mistakes):
```bash
kubectl create secret generic mytechstore-secret --from-literal=DB_PASSWORD=rootpass
```

**Deployment env vars updated to reference both, instead of `value:` literals:**
```yaml
          env:
            - name: DB_HOST
              valueFrom:
                configMapKeyRef:
                  name: mytechstore-config
                  key: DB_HOST
            - name: DB_NAME
              valueFrom:
                configMapKeyRef:
                  name: mytechstore-config
                  key: DB_NAME
            - name: DB_USER
              valueFrom:
                configMapKeyRef:
                  name: mytechstore-config
                  key: DB_USER
            - name: DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mytechstore-secret
                  key: DB_PASSWORD
```

Applied the identical pattern to MySQL's own Deployment (`MYSQL_DATABASE`
from the same ConfigMap, `MYSQL_ROOT_PASSWORD` from the same Secret) —
demonstrating that ConfigMaps/Secrets are shared cluster resources any
number of Pods can reference, not tied to a single Deployment.

### Verified result
Both MyTechStore and MySQL connected/started successfully with zero code
changes — same env var names (`DB_HOST`, etc.) the Java app already read,
just sourced from ConfigMap/Secret instead of literal strings. Re-verified
the MySQL data (`SELECT COUNT(*) FROM produit` → 18) survived the Deployment
update that switched its password source — confirming this was a clean
config change, not a data-impacting one.

### Key takeaway
Kubernetes Secrets ≠ encryption. Anyone with `kubectl get secret -o yaml` +
`base64 --decode` access can read the value trivially — proven directly:
```bash
kubectl get secret mytechstore-secret -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
# → rootpass
```
The real value of Secrets at this stage is separation from source-controlled
manifests, not confidentiality by itself — that comes from RBAC (queued for
later).

---

## Part 2 — Resources (Requests & Limits)

**Goal:** govern how much CPU/memory each container can use, so a single
misbehaving Pod can't starve a node and so the scheduler can make informed
placement decisions.

### Concepts
- **Requests** — minimum guaranteed amount; used by the **scheduler** to
  decide which node has room for a Pod.
- **Limits** — hard ceiling enforced at runtime. Exceeding a **memory**
  limit → container is OOMKilled. Exceeding a **CPU** limit → container is
  throttled, not killed.

### Applied to both Deployments
```yaml
          resources:
            requests:
              cpu: "250m"
              memory: "512Mi"
            limits:
              cpu: "500m"
              memory: "768Mi"   # 1Gi for the MySQL container
```

### Required: metrics-server installation
Not installed by default on a self-managed kubeadm cluster (unlike some
managed offerings). Installed via:
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### What broke / mistakes

- **metrics-server crash-looped after install** — kubeadm-provisioned
  kubelets typically use self-signed certificates without the SANs
  metrics-server expects by default, causing TLS verification failures.
  **Fix:**
  ```bash
  kubectl patch deployment metrics-server -n kube-system --type='json' \
    -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
  ```
  **Note:** acceptable for a learning cluster under full personal control;
  not a default choice for a real production cluster without understanding
  the tradeoff (trusting kubelet identity without verifying its certificate).

### Verified real usage via `kubectl top`
```
mysql-deployment:       432Mi used  (request 512Mi, limit 1Gi)
mytechstore-deployment: ~200-220Mi used per Pod (request 512Mi, limit 768Mi)
```
Actual usage sitting comfortably under configured requests — confirmed
requests weren't starving anything, with headroom to spare on both nodes
(cluster-worker at 38% memory used, cluster-master at 24%).

### Hands-on proof — deliberate OOMKill

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: memory-stress-test
spec:
  containers:
    - name: stress
      image: polinux/stress
      resources:
        requests:
          memory: "50Mi"
        limits:
          memory: "100Mi"
      command: ["stress"]
      args: ["--vm", "1", "--vm-bytes", "200M", "--vm-hang", "1"]
```
Result, verified via `kubectl describe pod`:
```
State:          Terminated
  Reason:       OOMKilled
  Exit Code:    137
Restart Count:  3
```
`Exit Code: 137` = SIGKILL, the standard signal for an OOM termination.
Kubernetes kept retrying per its restart policy, hitting the same 100Mi
ceiling each time — container stayed contained to its own limit without
affecting any other Pod on the node.

### Key takeaway
Resource limits are the mechanism that prevents one runaway container from
destabilizing an entire node's other workloads (including unrelated Pods
like the MySQL StatefulSet or CoreDNS sharing the same node) — proven
directly rather than taken on faith.

---

## Part 3 — StatefulSets

**Goal:** replace the manually-wired MySQL Deployment (hand-pinned to a
node via `nodeSelector`, single hardcoded PVC) with the architecturally
correct workload type for stateful applications.

### Why Deployments are the wrong fit for databases

Deployment Pods are designed to be **stateless and interchangeable** — any
replica can serve any request, none "own" unique state, and Pod names are
random hashes that change on every recreation. The MySQL Deployment from
Phase 5 only worked by manually working around this mismatch:
- Pinning to `cluster-worker` via `nodeSelector`, since storage lived on
  that node's local disk
- A single hardcoded PVC, which would break under `replicas > 1` (multiple
  Pods can't safely share one `ReadWriteOnce` volume for a database)
- No stable network identity — if this were a multi-replica database
  needing specific-node addressing (e.g. leader election), a Deployment
  couldn't support it at all

### What a StatefulSet actually provides
1. **Stable, predictable Pod names** — `mysql-0`, not a random hash;
   survives Pod recreation with the *same* name.
2. **Stable per-Pod network identity** via a **headless Service**
   (`clusterIP: None`) — e.g. `mysql-0.mysql-headless.default.svc.cluster.local`
   resolves to that exact Pod, distinct from a regular load-balanced Service.
3. **Automatic, per-replica PersistentVolumeClaims** via
   `volumeClaimTemplates` — each replica gets its own PVC automatically,
   rather than replicas competing for one shared claim.
4. **Ordered, sequential scaling/updates** — Pod 0 before Pod 1, etc.
   (not strongly exercised at `replicas: 1`, but the correct foundation
   for future scaling).

### Manifests

**New PV, using a named StorageClass so the auto-generated PVC can bind to it:**
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv-0
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data/mysql
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
```

**Headless Service (new — required by StatefulSets for per-Pod DNS):**
```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql-headless
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
```
The original `mysql-service` (regular ClusterIP, used by MyTechStore)
remains unchanged — both Services can coexist, selecting the same Pods.

**The StatefulSet:**
```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql-headless
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
              valueFrom:
                configMapKeyRef:
                  name: mytechstore-config
                  key: DB_NAME
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mytechstore-secret
                  key: DB_PASSWORD
          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql
  volumeClaimTemplates:
    - metadata:
        name: mysql-storage
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: manual
        resources:
          requests:
            storage: 2Gi
```
`volumeClaimTemplates` replaces the old standalone PVC file — Kubernetes
auto-generates a PVC (`mysql-storage-mysql-0`) and binds it to `mysql-pv-0`
by matching `storageClassName` and capacity.

### Verified end-to-end, all three StatefulSet guarantees proven live

1. **Stable identity:** Pod came up named `mysql-0` (not a random hash) on
   first apply.
2. **Stable per-Pod DNS:**
   ```bash
   nslookup mysql-0.mysql-headless
   # → mysql-0.mysql-headless.default.svc.cluster.local, resolved to the exact Pod IP
   ```
3. **Identity + storage survive Pod deletion:**
   ```bash
   kubectl delete pod mysql-0
   kubectl get pods -l app=mysql -w
   # replacement Pod comes back named "mysql-0" again — not a new random name
   kubectl exec -it mysql-0 -- mysql -uroot -prootpass mytechstore -e "SELECT COUNT(*) FROM produit;"
   # → 18 (unchanged, automatically reattached to the same PVC)
   ```

### Key takeaway — when to actually use a StatefulSet

Not a blanket rule for "anything stateful." The real test: **does this Pod
need to be individually addressable, and does its storage need to survive
tied specifically to that identity?**

- **Use StatefulSet:** databases with multiple replicas/replication
  (MySQL replicas, Postgres streaming replication), distributed systems
  with leader election or sharding (Kafka, Elasticsearch, Cassandra,
  Zookeeper) — anywhere "which specific instance" matters.
- **Deployment is correct and simpler:** stateless apps (MyTechStore's
  Tomcat Pods — any replica serves any request), simple non-clustered
  caches (e.g. single-instance Redis).
- **Neither:** batch/one-off workloads belong on Jobs/CronJobs (not yet covered).
- **Worth knowing:** even a single-replica database (this project's current
  state) benefits from StatefulSet over Deployment — not for the
  multi-replica guarantees (not yet exercised at `replicas: 1`), but because
  `volumeClaimTemplates` is simply a cleaner, less error-prone pattern than
  manually wiring a PV + PVC + `nodeSelector` by hand. It's also the
  correct foundation if real replication is ever added later, with no
  architecture rewrite needed.
- **Also worth knowing:** real production teams often avoid self-managing
  databases in Kubernetes entirely, using managed services (RDS, Cloud SQL)
  instead — or use a dedicated Operator (e.g. a Postgres/MySQL Operator)
  for more complex, self-managed cases, rather than hand-writing
  StatefulSet YAML for anything non-trivial.

---

## Key Takeaways — Phase 6

- **Secrets are encoded, not encrypted** — real confidentiality requires
  RBAC and/or external secret-management tooling on top.
- **Resource limits directly protect cluster stability** — proven with a
  live OOMKill rather than taken on faith; a contained failure stays
  contained to its own Pod instead of destabilizing the node.
- **metrics-server isn't included by default on self-managed clusters**,
  and typically needs `--kubelet-insecure-tls` against kubeadm-provisioned
  kubelets — a concrete, self-managed-cluster-specific gotcha.
- **Deployment vs. StatefulSet is a judgment call based on identity and
  storage-binding needs, not a fixed rule tied to "is this stateful."**
  Correctly reasoning through this distinction (and why random Pod names
  break scenarios like leader election) independently, before being told,
  was a genuine shift from following instructions to engineering judgment.
- **Migrating a live workload's architecture (Deployment → StatefulSet)
  without losing data** is achievable safely by reusing the same underlying
  `hostPath` directory and being deliberate about PV/PVC cleanup order —
  verified with a real before/after row-count check.

---

## Next Up

- **Cluster operations** — covered at a theory level only, not yet hands-on:
  Namespaces, node cordon/drain for maintenance, kubeadm cluster/component
  upgrades, etcd backup/restore, namespace-level ResourceQuotas/LimitRanges.
  Plan: practice Namespaces and cordon/drain hands-on first (low-risk,
  directly observable on this 2-node cluster); treat etcd backup/restore
  and full version upgrades more conceptually for now, given the risk of
  disrupting the live MyTechStore deployment.
- **CI/CD → Kubernetes** — connecting the existing GitLab CI pipeline to
  actually deploy to the cluster (not just build/push the image).
- RBAC and Helm — deliberately deferred to a later phase.
- Portfolio/CV checkpoint — still pending, increasingly overdue given the
  depth of what's been built.
