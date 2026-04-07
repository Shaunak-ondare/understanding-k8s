# Setting Up an Ingress Controller (Kind on EC2)

Since you are running **Kind** on an **EC2 instance**, there are a few specific steps to ensure your Ingress is accessible.

## 1. Kind Cluster Configuration (Prerequisite)
For Ingress to work on Kind, your cluster must be created with **extraPortMappings**. If you haven't done this, you may need to recreate your cluster with a config file like this:

```yaml
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
```
*Create with: `kind create cluster --config kind-config.yaml`*

## 2. Install NGINX Ingress Controller
Run this command tailored for Kind:
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
```

## 3. EC2 Security Group Setup
> [!IMPORTANT]
> You MUST go to your **AWS Console** and update the **Security Group** of your EC2 instance to allow inbound traffic on:
> - **Port 80 (HTTP)**
> - **Port 443 (HTTPS)**
> Without this, you won't be able to reach the Ingress from your local browser.

## 4. Accessing the App
Since you defined `quote-app.local` in `ingress.yaml`, you have two options:
1.  **Local Hosts File**: Map the **EC2 Public IP** to `quote-app.local` in your local computer's `/etc/hosts` (Mac/Linux) or `C:\Windows\System32\drivers\etc\hosts` (Windows).
2.  **Magic DNS**: Change the host in `ingress.yaml` to include your EC2 IP using a service like sslip.io:
    *   Example: `quote-app.[YOUR-EC2-IP].sslip.io`
