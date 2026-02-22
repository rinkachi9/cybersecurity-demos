# Service Mesh Security: mTLS and Zero Trust in GKE

At a senior/architect level, we move away from simple IP-based firewall rules towards a **Zero Trust** model based on **Identity**.

## 🛡️ What is a Service Mesh (e.g., Istio/Anthos Service Mesh)?
A Service Mesh is an infrastructure layer (usually a set of `sidecar` containers) that manages communication between microservices. In a security context, it provides three key functions:

### 1. Mutual TLS (mTLS) – "Zero Trust" inside the cluster
- **Problem**: The traditional network inside Kubernetes is "open." Any Pod can listen in on the traffic of other Pods (Man-in-the-Middle).
- **Solution**: **mTLS**. Service Mesh automatically encrypts all traffic between services. Crucially, both services must identify themselves with a valid certificate (Mutual Auth), which prevents spoofing.
- **STRICT Mode**: Our demo configures `PeerAuthentication` in `STRICT` mode, meaning no service in the cluster will accept a connection without mTLS.

### 2. Identity-based Authorization (Role-based Access Control)
- **Problem**: IP addresses in Kubernetes are ephemeral. Firewall rules based on IP are difficult to maintain.
- **Solution**: `AuthorizationPolicy`. We allow, for example, only the `frontend` service (identified by its **Service Account**) to connect to the `backend` service. Even if an attacker takes over another container in the cluster, they will not be able to establish a connection with the backend.

### 3. Request Authentication (JWT & End-user Identity)
- Service Mesh can automatically verify **JWT** tokens (e.g., from Google Identity or Auth0) at the network edge before the request even reaches your application.

## 🛠️ How to Implement?
1. Enable `Anthos Service Mesh` (or install Istio) on the GKE cluster.
2. Configure `Workload Identity` (IAM identity for Pods).
3. Apply the `kubernetes/mesh-security.yaml` manifests in your namespace.

---
*Reference: [GCP Anthos Service Mesh Security](https://cloud.google.com/service-mesh/docs/overview)*
