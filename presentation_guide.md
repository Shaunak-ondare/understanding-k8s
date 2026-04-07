# Project Presentation: Understanding Kubernetes Concepts

## Project Title: **Cloud-Native Mastery: From Code to Scalable Infrastructure**

---

### 1. Executive Summary
This project demonstrates a complete, production-ready Kubernetes ecosystem. It transforms a simple Go-based "Quote App" into a highly available, auto-scaling, and monitorable microservice deployed via a modern CI/CD pipeline.

### 2. Key Components & Architecture

#### **A. The Application (The Heart)**
-   **Language**: Go (Golang)
-   **Functionality**: Serves a static frontend and provides a `/metrics` endpoint for observability.
-   **Containerization**: Optimized Docker image (multi-stage builds possible) pushed to Docker Hub.

#### **B. Infrastructure Orchestration (The Skeleton)**
-   **Kubernetes (K8s)**: The orchestrator managing containers.
-   **ReplicaSet/Deployment**: Ensures 3 replicas are always running. If a pod crashes, K8s restarts it automatically (Self-healing).
-   **Services**: A `ClusterIP` service acts as a stable internal load balancer for the pods.

#### **C. Traffic Management (The Gateway)**
-   **NGINX Ingress Controller**: Manages external access. Instead of exposing each service on a random port, the Ingress Controller routes traffic from `localhost` (or a domain) to the correct internal service based on rules.

#### **D. Dynamic Scaling (The Muscle)**
-   **Metrics Server**: The "brain" that watches resource usage.
-   **Horizontal Pod Autoscaler (HPA)**:
    -   Scales from **2 to 10 pods**.
    -   Triggers scaling if **CPU usage > 30%** or **Memory usage > 60%**.
    -   Ensures the app handles traffic spikes without human intervention.

#### **E. Observability (The Eyes)**
-   **Prometheus**: Periodically "scrapes" metrics from the Go app. It collects data on request counts, latency, and system health.
-   **Grafana**: (Optionally integrated) Visualizes the data from Prometheus into beautiful dashboards.

#### **F. CI/CD Pipeline (The Engine)**
-   **GitHub Actions**: 
    -   **Automation**: Triggered on every code push.
    -   **Build**: Compiles the Go code and builds the Docker image.
    -   **Push**: Dispatches the image to Docker Hub (`shaunakondare/quote-app`).
    -   **Deploy**: Automatically updates the Kubernetes cluster with the latest image.

---

### 3. How Everything Works Together (Step-by-Step)

1.  **Developer Pushes Code**: A developer updates the "Quote App" and pushes to GitHub.
2.  **Pipeline Ignites**: GitHub Actions catches the change, builds a new Docker image, and tags it `latest`.
3.  **Deployment Update**: The pipeline tells the K8s cluster to use the new image.
4.  **Rolling Update**: K8s performs a "Rolling Update"—it starts new pods before killing old ones, ensuring **Zero Downtime**.
5.  **Traffic Flow**: A user hits `localhost`. The **Ingress Controller** receives the request and forwards it to the **Quote App Service**, which then load-balances it to one of the healthy **Pods**.
6.  **Monitoring**: **Prometheus** continuously talks to the pods to collect health data.
7.  **Auto-Scaling**: If the user traffic increases, the **Metrics Server** detects high CPU. The **HPA** immediately spins up more pods to share the load.

---

### 4. Technical Highlights for the Team
-   **Declarative Infrastructure**: Everything is defined in YAML (Infrastructure as Code).
-   **Scaling Resilience**: The app reacts to load in seconds.
-   **Observability**: We don't guess if the app is healthy; we see it in the metrics.
-   **Security**: Use of OIDC for GitHub Actions to AWS (if applicable) and resource limits (requests/limits) to prevent "noisy neighbor" issues.

---

### 5. Future Roadmap
-   Integration with Service Mesh (Istio/Linkerd).
-   Blue/Green deployments for even safer releases.
-   Secret management using HashiCorp Vault or AWS Secrets Manager.
