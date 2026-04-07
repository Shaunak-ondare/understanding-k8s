# Setting Up Ingress & Monitoring (Kind on EC2)

Since you are running **Kind** on an **EC2 instance**, there are a few specific steps to ensure your Ingress and Monitoring are accessible.

## 1. Kind Cluster Configuration (Prerequisite)
Your cluster must be created with **extraPortMappings**. Use the **[kind-config.yaml](file:///c:/Users/shaun/Documents/Projects/k8s-concepts/kind-config.yaml)** provided in the root:

```bash
kind create cluster --config kind-config.yaml
```

## 2. Install Ingress Controller
I have saved the official Kind manifest locally. Apply it:
```bash
kubectl apply -f k8s/ingress-controller.yaml
```
*Wait for the ingress pods to be ready:*
```bash
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
```

## 3. Install Monitoring (Prometheus & Grafana)
Apply the manifests in the `monitoring` directory:
```bash
kubectl apply -f k8s/monitoring/prometheus.yaml
kubectl apply -f k8s/monitoring/grafana.yaml
```

## 4. EC2 Security Group Setup
> [!IMPORTANT]
> You MUST go to your **AWS Console** and update the **Security Group** of your EC2 instance to allow inbound traffic on:
> - **Port 80 (HTTP)**
> - **Port 443 (HTTPS)**

## 5. Accessing your Resources
Since these are using Ingress, you need to map their hostnames to your **EC2 Public IP** in your local machine's `hosts` file:

| Service | Hostname | Ingress Manifest |
| :--- | :--- | :--- |
| **Quote App** | `quote-app.local` | `k8s/ingress.yaml` |
| **Grafana** | `grafana.local` | `k8s/monitoring/grafana.yaml` |

### **On Windows (Local)**
Add these lines to `C:\Windows\System32\drivers\etc\hosts`:
```text
[EC2-PUBLIC-IP]  quote-app.local
[EC2-PUBLIC-IP]  grafana.local
```

### **On Mac/Linux (Local)**
Add these lines to `/etc/hosts`:
```bash
[EC2-PUBLIC-IP]  quote-app.local
[EC2-PUBLIC-IP]  grafana.local
```

Once mapped, you can visit **`http://quote-app.local`** and **`http://grafana.local`** in your browser!
