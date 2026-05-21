# 01. Adopt a Zero Trust Network Model

Traditional perimeter security assumes that the internal network is trusted and the external network is hostile. That model is not sufficient for cloud environments, remote work, SaaS integrations, service-to-service APIs, and compromised credentials. Zero Trust shifts the security decision from network location to identity, context, device state, and explicit authorization.

## What is Zero Trust?

**Zero Trust** is a security model based on the principle "never trust, always verify." A request is not trusted just because it originates from an internal IP range, VPN, office network, or private subnet. Every access request should be authenticated, authorized, encrypted, logged, and evaluated against context.

Core concepts:

- **Identity-aware access**: users and workloads are authenticated before access is granted.
- **Context-aware access**: device posture, source location, risk, and time can affect authorization.
- **Least privilege**: access is scoped to the minimum required resource and action.
- **Microsegmentation**: workloads are isolated so one compromise does not expose the whole network.
- **Continuous verification**: access is logged, monitored, and reviewed.

## Architectural context

In Google Cloud, Zero Trust is usually implemented through a combination of IAM, IAP, Context-Aware Access, service accounts, firewall policies, mTLS, private access, and centralized logging. It is not one product. It is an architecture pattern.

Useful GCP controls include:

- Identity-Aware Proxy for web apps, SSH, and RDP access;
- Context-Aware Access and Access Context Manager for device and location rules;
- service account based firewall rules for workload identity;
- mTLS through service mesh for workload-to-workload traffic;
- VPC Service Controls for API-level data perimeters;
- Cloud Audit Logs and VPC Flow Logs for verification.

## Threats and failure modes this protects against

- **Stolen VPN credentials** used to access internal applications.
- **Lateral movement** after a VM, container, or user account is compromised.
- **Flat network compromise** where one subnet can reach all sensitive services.
- **Trusted internal attacker** abusing location-based trust.
- **Phishing impact** when authentication is valid but device or context is suspicious.
- **Unmanaged device access** to administrative panels or sensitive applications.

## Implementation guidance for GCP

1. Put administrative web applications behind IAP instead of exposing them directly.
2. Require MFA and device posture for privileged access.
3. Replace broad IP-based allow rules with service account based firewall rules.
4. Use separate service accounts per workload and environment.
5. Segment workloads by function, sensitivity, and environment.
6. Encrypt service-to-service traffic with TLS or mTLS.
7. Log access decisions and denied requests for review.
8. Design break-glass access separately and monitor it aggressively.

## Validation and evidence

Useful evidence includes:

- IAP configuration for administrative or internal applications;
- negative test output showing unauthenticated access is blocked;
- firewall rules targeting service accounts instead of broad CIDR ranges;
- Access Context Manager levels for managed devices or trusted networks;
- logs showing denied access from an untrusted device or location.

## Common mistakes

- Calling a private subnet "Zero Trust" without identity-aware controls.
- Keeping broad internal allow rules such as `10.0.0.0/8 -> all`.
- Using VPN as the only security boundary.
- Applying Zero Trust only to human users and not to workloads.
- Not logging denied access, which makes policy tuning difficult.

## Checklist

- [ ] Critical applications require identity-aware access.
- [ ] Privileged access uses MFA and contextual controls.
- [ ] Firewall rules are based on service identity where possible.
- [ ] Workloads are segmented by environment and sensitivity.
- [ ] Service-to-service traffic is encrypted.
- [ ] Denied access and policy changes are logged and reviewed.

---
Reference: [Zero Trust architecture on Google Cloud](https://cloud.google.com/architecture/zero-trust-architecture-on-google-cloud)
