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
