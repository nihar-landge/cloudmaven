# Docker Assignment

This folder contains the Docker assignment for the Cloudmaven course. It includes:

- A **Flask application** (`app.py`) containerized using Docker.
- A **multi-stage Dockerfile** that builds dependencies in a builder image and copies them into a slim runtime image.
- Screenshots that document the steps and outputs from building and running the container.

---

## 📌 Key Steps Covered (as seen in the screenshots)

1. **Checking Docker version** and ensuring Docker is installed.
2. **Building the Docker image** for the Flask app and tagging it.
3. **Running the container** and verifying it is up (`docker ps`).
4. **Using `docker exec`** to inspect the running container filesystem.
5. **Inspecting Docker resources** (images, volumes, networks).
6. **Testing connectivity** from inside a container (DNS/network access).
7. **Reviewing the Dockerfile** to confirm the multi-stage build and runtime setup.

---

## 🖼 Screenshots

The following screenshots document the assignment steps and outputs:

| Screenshot | Description |
|-----------|-------------|
| ![T1.1](./screenshots/T1.1.png) | Docker version output (Docker is installed) |
| ![T1.2](./screenshots/T1.2.png) | `docker exec` into the Flask container and listing files |
| ![T1.3](./screenshots/T1.3.png) | `docker ps` showing running containers |
| ![T1.4](./screenshots/T1.4.png) | `.dockerignore` contents |
| ![T1.5](./screenshots/T1.5.png) | Docker volume inspect output |
| ![T1.6](./screenshots/T1.6.png) | Dockerfile content (multi-stage build) |
| ![T2.1](./screenshots/T2.1.png) | `docker ps` showing two containers running |
| ![T2.2](./screenshots/T2.2.png) | Docker network list output |
| ![T2.3](./screenshots/T2.3.png) | Container pinging another container by name |
| ![T2.4](./screenshots/T2.4.png) | `docker images` output showing built images |
| ![T2.5](./screenshots/T2.5.png) | `docker exec` network test showing DNS failure in isolated container |
| ![T3.1](./screenshots/T3.1.png) | Container inspect output showing memory/cgroup limits |
| ![T3.2](./screenshots/T3.2.png) | `docker inspect` output showing bind mount to local folder |
| ![T3.3](./screenshots/T3.3.png) | Docker build output showing build stages |
| ![T3.4](./screenshots/T3.4.png) | `docker network inspect` showing container IPs on custom network |
| ![T4.4](./screenshots/T4.4.png) | `curl localhost:80` showing Nginx default page (host-level check) |
| ![T5.1](./screenshots/T5.1.png) | Dependency vulnerability report (Python packages) |
| ![T5.2](./screenshots/T5.2.png) | Dependency vulnerability report (continued) |

---

## 🧪 Running the App Locally (Development)

From the `Docker-assignment` folder:

```sh
# Build the Docker image
docker build -t library-app:v1 .

# Run the container (port 5000 exposed)
docker run -d --name my-library-app -p 5000:5000 library-app:v1
```

Then open `http://localhost:5000` in your browser.

---

## 📘 Docker Concepts (Image vs Container vs Volume vs Network)

- **Image**: A read-only, versioned filesystem template built from a `Dockerfile`. Images are immutable artifacts that can be pushed/pulled from registries.
- **Container**: A running instance of an image. Containers add a writable layer on top of the image and run isolated processes.
- **Volume**: A persistent data store managed by Docker. Volumes survive container restarts and removals, and are the recommended way to keep state (databases, logs, etc.).
- **Network**: A virtual network that allows containers to communicate (and optionally connect to the host or external networks). Docker provides default networks (bridge, host, none) and supports custom user-defined networks.

---

## 🧹 Cleaning up Unused Docker Resources

Docker can accumulate images, containers, volumes, and networks over time. The following commands help reclaim disk space:

- `docker system df` — show disk usage.
- `docker container prune` — remove stopped containers.
- `docker image prune` — remove dangling images.
- `docker volume prune` — remove unused volumes.
- `docker network prune` — remove unused networks.
- `docker system prune -a` — remove all unused containers, networks, and images (use with caution).

> ⚠️ Always double-check what will be removed before running prune commands, especially in shared environments.

---

## 🔒 Best Practices for Secure Dockerfiles

- **Use minimal base images** (e.g., `python:3.11-slim`, `alpine`) to reduce the attack surface.
- **Pin versions** (e.g., `python:3.11.6-slim`) to avoid unintended changes when upstream images update.
- **Use multi-stage builds** to keep runtime images small and avoid shipping build-time dependencies.
- **Run as a non-root user** whenever possible (e.g., `USER appuser`).
- **Avoid storing secrets** in the Dockerfile or image (use build args, environment variables, or secret management solutions).
- **Limit layers** by combining commands where sensible (e.g., `RUN apt-get update && apt-get install -y ... && rm -rf /var/lib/apt/lists/*`).
- **Scan images** regularly for vulnerabilities using tools like `docker scan`, `trivy`, or `clair`.
- **Set explicit ports and health checks** (e.g., `HEALTHCHECK CMD curl -f http://localhost:5000/health || exit 1`).

---
>>>>>>> 1e1e138 (Update Docker assignment README with documentation section)
