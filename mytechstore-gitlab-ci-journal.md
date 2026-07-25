# MyTechStore — Containerizing a Real Java Servlet App + GitLab CI

> DevOps learning journey, Phase 3: taking an existing real-world project
> (not a toy app) and containerizing it end-to-end, then automating the
> build/push pipeline with GitLab CI.
> Background: Sysadmin/IT, learning hands-on via projects.
> Follows Phase 2: dockerfile-cicd-journal.md

---

## Project Overview

**MyTechStore** — an existing Java servlet-based tech store application.

**Stack:**
- Java 11
- Jakarta EE 5.0 (`jakarta.servlet-api` 5.0.0, JSP, JSTL)
- Maven (packaged as WAR)
- MySQL via JDBC (`mysql-connector-java`)
- jbcrypt (password hashing)

**Goal:** Take this real, pre-existing app — not a toy hello-world — and:
1. Containerize it with a proper multi-stage Dockerfile
2. Run it alongside MySQL via Docker Compose, with correct container networking
3. Automate build + image push with a GitLab CI pipeline

---

## Part 1 — Containerizing the App

### Critical compatibility discovery: Jakarta EE 5.0 requires Tomcat 10+

The `pom.xml` uses `jakarta.servlet-api` version `5.0.0`, which uses the
**`jakarta.*`** namespace. Tomcat 9 and earlier use the older **`javax.*`**
namespace — deploying this WAR to Tomcat 9 would fail. **Tomcat 10+ is
required** for Jakarta EE 5.0+ compatibility.

### Dockerfile (multi-stage: Maven build → Tomcat runtime)

```dockerfile
FROM maven:3.9-eclipse-temurin-11 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package

FROM tomcat:10-jdk11
COPY --from=builder /app/target/MyTechStore.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

Copying the WAR as `ROOT.war` deploys it at the root context path (`/`),
rather than `/MyTechStore`.

### docker-compose.yml (app + MySQL)

```yaml
services:
  app:
    build: .
    ports:
      - "8081:8080"
    depends_on:
      - db
    environment:
      DB_HOST: db
      DB_NAME: mytechstore
      DB_USER: root
      DB_PASSWORD: rootpass

  db:
    image: mysql:8
    environment:
      MYSQL_DATABASE: mytechstore
      MYSQL_ROOT_PASSWORD: rootpass
    volumes:
      - db-data:/var/lib/mysql
      - ./schema.sql:/docker-entrypoint-initdb.d/init.sql
    ports:
      - "3307:3306"

volumes:
  db-data:
```

---

## Part 2 — Fixing the Hardcoded DB Connection (Safely)

### The problem

`DBConnection.java` had a **hardcoded** JDBC URL pointing to `127.0.0.1:3306`.
Inside Docker, `127.0.0.1` refers to the **app container itself**, not the
separate MySQL container — this needed to become the Compose **service name**
(`db`) instead.

### The safe-change approach (avoiding fear of breaking working code)

Rather than hardcoding the Docker-specific value directly (which would break
local, non-Docker development), the fix uses **environment variables with
fallback defaults matching the original hardcoded values**:

```java
private static final String DB_HOST = System.getenv().getOrDefault("DB_HOST", "127.0.0.1");
private static final String DB_NAME = System.getenv().getOrDefault("DB_NAME", "mytechstore");
private static final String USER = System.getenv().getOrDefault("DB_USER", "root");
private static final String PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "test");
```

This means: running the app the old way (no env vars set) behaves **identically**
to before. Running it via Compose (which sets `DB_HOST=db`, etc.) connects to
the containerized MySQL instead. Zero risk to the existing local setup.

### Git workflow used to de-risk the change

```bash
git checkout -b docker-db-config
# make the edit, test in Docker
# if something breaks: git checkout main — original file untouched
```

**Key takeaway:** this is exactly the real-world use case for Git branches —
trying a change with zero risk to what already works, rather than editing
`main` directly out of fear of breaking things.

---

## Part 3 — Debugging Log (in the order issues occurred)

### 1. Docker daemon unreachable
```
unable to get image 'mysql:8': Cannot connect to the Docker daemon...
```
**Cause:** Docker Desktop wasn't running / Docker context mismatch.
**Fix:** confirmed Docker daemon was running via `systemctl status docker`
(or restarted Docker Desktop).

### 2. MySQL port conflict (host port 3306 already in use)
```
failed to bind host port 0.0.0.0:3306/tcp: address already in use
```
**Cause:** a local MySQL installation was already running on the host,
bound to the same port the `db` container tried to claim.
**Fix chosen:** stopped the local MySQL service (`sudo systemctl stop mysql`)
rather than remapping the container's host port — since the app container
only needs to reach `db:3306` internally, not the host at all.
**Note:** `systemctl stop` is temporary — the service returns on reboot
unless separately `disable`d.

### 3. App port conflict (8081 already in use)
Same root cause pattern as #2, this time on the app's port. Resolved by
mapping to a free host port in `docker-compose.yml`'s `ports:` section
(host-side number only — container-side stays 8080, Tomcat's default).

### 4. 500 error: `Table 'mytechstore.produit' doesn't exist`
**Cause:** the connection to MySQL was working correctly (confirmed via
`docker compose logs app`) — the actual issue was that the **fresh
container's database was empty**. All schema/data lived only in the
previously-stopped local MySQL instance; the new containerized MySQL starts
from a blank database every time.
**Fix:** mounted an existing SQL schema/dump file into MySQL's official
auto-init directory:
```yaml
volumes:
  - ./schema.sql:/docker-entrypoint-initdb.d/init.sql
```
**Critical detail:** this only runs on a **completely fresh volume** — since
a volume had already been created (and "initialized" as empty) on the first
`docker compose up`, the schema file was ignored until the volume was wiped:
```bash
docker compose down -v   # -v removes the volume, forcing re-initialization
docker compose up -d --build
```

**Key takeaway:** "connection succeeded" and "data exists" are two separate
things to verify — a clean DB connection log doesn't mean the schema is
populated. This is also the correct, reproducible pattern for seeding a
database in any fresh environment (a teammate's machine, a CI pipeline, etc.)
rather than relying on a database that happens to already have data on one
specific machine.

---

## Part 4 — GitLab CI Pipeline

### Setup friction (Git/auth, before the pipeline itself)

1. **GitLab also requires a Personal Access Token**, not an account
   password, for `git push` over HTTPS — same underlying cause as the
   earlier GitHub Actions PAT issue, different platform.

2. **"Repository not found" on push** — turned out to be a **different
   username between platforms** (GitHub vs. GitLab usernames didn't match:
   `ayoubbakhyi` vs `ayoub.bakhyi`), producing a URL that pointed at a
   nonexistent repo path.

3. **Diverged/unrelated histories** — the GitLab project had been
   initialized with its own initial commit (e.g. auto-created README),
   conflicting with the separately-initialized local repo.
   **Fix:**
   ```bash
   git config pull.rebase false
   git pull gitlab main --allow-unrelated-histories
   git push gitlab main
   ```
   **Lesson for future projects:** create new remote repos completely
   empty (no README/`.gitignore`/license auto-added) when planning to push
   an existing local repo, to avoid this entirely.

### `.gitlab-ci.yml`

```yaml
stages:
  - build
  - package
  - push

variables:
  MAVEN_OPTS: "-Dmaven.repo.local=.m2/repository"
  IMAGE_TAG: "$CI_REGISTRY_IMAGE:latest"

build:
  stage: build
  image: maven:3.9-eclipse-temurin-11
  script:
    - mvn clean package
  artifacts:
    paths:
      - target/*.war
    expire_in: 1 hour

build_image:
  stage: package
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $IMAGE_TAG .
  needs:
    - build

push_image:
  stage: push
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker build -t $IMAGE_TAG .
    - docker push $IMAGE_TAG
  needs:
    - build_image
  only:
    - main
```

### GitLab CI-specific config errors hit (neither exists in GitHub Actions)

1. **"Circular dependencies: self-dependency: package"**
   **Cause:** a *job* was named `package`, identical to the *stage* named
   `package`. GitLab's dependency graph got confused by the name collision.
   **Fix:** renamed the job to `build_image` (kept the stage name `package`
   as-is).
   **Lesson:** never name a job identically to a stage in GitLab CI.

2. **"undefined need: package"**
   **Cause:** after the rename above, a `needs:` reference elsewhere in the
   file still pointed at the old job name (`package`) instead of the new one
   (`build_image`). `needs:` must reference actual job names, not stage names.
   **Fix:** updated all `needs:` references to match the renamed jobs.

### Verified result

Pipeline ran green end-to-end: Maven build → Docker multi-stage image build
→ push to GitLab's built-in Container Registry (`$CI_REGISTRY_IMAGE`) — no
manual Docker Hub account/token setup required, since GitLab provides
registry credentials automatically via CI/CD variables.

---

## Key Takeaways — Phase 3

- **Framework/runtime version compatibility matters at the infrastructure
  level, not just the code level** — Jakarta EE 5.0 requiring Tomcat 10+ is
  exactly the kind of constraint that only becomes visible when actually
  containerizing an app, not just reading its `pom.xml`.
- **Environment variables with safe fallback defaults** are a low-risk way
  to make existing code Docker-compatible without changing its behavior
  outside Docker.
- **A successful DB connection log line does not mean the database has data**
  — schema/data seeding is a separate concern, solved here via
  `docker-entrypoint-initdb.d`, which only triggers on a fresh volume.
- **GitLab CI has its own YAML gotchas distinct from GitHub Actions** —
  job/stage name collisions and stale `needs:` references are two that
  don't have an equivalent failure mode in GitHub Actions' structure.
- **Platform usernames aren't guaranteed to match across GitHub/GitLab/etc.**
  — worth double-checking the exact remote URL rather than assuming.
- **Git branches are the correct tool for "I'm afraid this change will break
  something that works"** — test on a branch, keep `main` untouched until
  confirmed working.

---

## Next Up

- Add a `test` stage to the GitLab CI pipeline using a live MySQL service
  container, to verify the app actually boots and connects during CI
  (not just that it builds).
- Kubernetes — the confirmed next major milestone after CI/CD tooling.
