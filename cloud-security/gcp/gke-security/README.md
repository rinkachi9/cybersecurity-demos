# GKE Security: Network Segmentation and Hardening

In Kubernetes environments, the default network posture often allows broad pod-to-pod communication. If one container is compromised, an attacker may scan services, access internal APIs, and move laterally inside the cluster. GKE hardening should combine network policies, workload identity, admission controls, image integrity, and runtime visibility.

## Key defensive mechanisms

### 1. Network Policies

- **Problem**: a flat cluster network allows unnecessary communication between workloads.
- **Control**: Kubernetes `NetworkPolicy` resources restrict ingress and egress at L3/L4.
- **Demo**: [example-policies.yaml](./network-policies/example-policies.yaml) shows a default-deny approach where traffic is blocked by default and only specific paths are opened, for example `frontend` to `backend` on port 8080.

### 2. Binary Authorization

Binary Authorization allows GKE to run only container images that were signed or attested by an approved build process. This reduces the risk of running unauthorized or malicious images.

### 3. Workload Identity

Pods should not use static JSON keys. Workload Identity maps a Kubernetes Service Account to a Google Cloud service account so workloads can access Google APIs with short-lived credentials.

### 4. Dataplane V2 and observability

GKE Dataplane V2 can enforce network policy and provide visibility into pod networking. Flow visibility helps validate segmentation and investigate lateral movement attempts.

## Deployment guidance for Network Policies

1. Ensure the cluster supports network policy enforcement, for example through GKE Dataplane V2.
2. Apply a `default-deny` policy in every namespace.
3. Add narrow `allow` rules based on `podSelector`, `namespaceSelector`, ports, and protocols.
4. Test both allowed and denied flows.
5. Keep policies in source control and review changes through CI.

## Validation evidence

- Applied `NetworkPolicy` manifests.
- Test output showing blocked cross-namespace or cross-tier traffic.
- Workload Identity mapping between Kubernetes and Google service accounts.
- Binary Authorization policy and attestation evidence.
- Flow logs or observability output for allowed and denied traffic.

---
Reference: [GKE network policies](https://cloud.google.com/kubernetes-engine/docs/how-to/network-policies)
