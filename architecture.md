# Project Architecture: Cloud-Native Mastery

This document outlines the technical structure and traffic flow of the Kubernetes ecosystem for the Quote App.

---

## 🗺️ Technical Architecture Diagram
This diagram shows the relationship between the users, the ingress controller, the application services, the scaling controller, and the monitoring system.

```mermaid
graph TD
    subgraph "External World (The User)"
        User([User / Web Browser]) --> |"http://quote-app.local"| Ingress[NGINX Ingress Controller]
    end

    subgraph "Kubernetes Cluster (Default Namespace)"
        Ingress --> |"Routes to Load Balancer (svc/80)"| Service[Quote App Service]
        
        subgraph "Application Compute (The Pods)"
            Service --> |"Traffic Distribution (Port 8080)"| Pod1[Pod: quote-app-1]
            Service --> |"Traffic Distribution (Port 8080)"| Pod2[Pod: quote-app-2]
            Service --> |"Traffic Distribution (Port 8080)"| Pod3[Pod: quote-app-3]
        end

        subgraph "Auto-Scaling & Control"
            HPA[Horizontal Pod Autoscaler] --> |"Scale Deployment"| Deployment[Quote App Deployment]
            MetricsServer[Metrics Server] -.-> |"Resource Usage (CPU/Mem)"| HPA
            Deployment -.-> |"Manages Lifecycle"| Pod1
            Deployment -.-> |"Manages Lifecycle"| Pod2
        end

        subgraph "Observability & Monitoring"
            Prom[(Prometheus Server)] -.-> |"Scrape /metrics"| Pod1
            Prom -.-> |"Scrape /metrics"| Pod2
            Prom -.-> |"Scrape /metrics"| Pod3
        end
    end

    subgraph "CI/CD & Automation (GitHub Actions)"
        GH[GitHub Actions Workflow] --> |"1. Build & Push Image"| DockerHub[(DockerHub)]
        DockerHub --> |"2. Update Deployment Image"| Deployment
    end
```

---

## 🔍 Detailed Component Flow

### 1. Traffic Routing (Ingress to Pod)
*   **User** → Hits the **NGINX Ingress Controller** (Port 80/443).
*   **Ingress** → Routes the request to the internal **ClusterIP Service**.
*   **Service** → A virtual IP that balances requests across the available healthy **Pods**.

### 2. The Auto-Scaling Loop (HPA)
*   **Metrics Server** → Periodically scrapes CPU and Memory usage from the container runtime (Kubelet).
*   **HPA** → Compares the current usage against the **30% CPU Target**.
*   **Deployment** → Adds or removes replicas to maintain the desired state.

### 3. Monitoring (Prometheus)
*   **Prometheus** → Automatically discovers our pods (via annotations) and pulls raw data from the `/metrics` endpoint.
*   **Data** → Can be used for alerting and visualization in Grafana.

### 4. Continuous Deployment (CI/CD)
*   **GitHub Actions** → Builds the [Dockerfile](file:///c:/Users/shaun/Documents/Projects/k8s-concepts/Dockerfile), pushes to **DockerHub**, and updates the cluster using the unique commit SHA.
