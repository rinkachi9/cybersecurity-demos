# 01. Adopt a Zero Trust Network Model

The traditional **"Castle and Moat"** security model is no longer sufficient. **Zero Trust** shifts security from the network perimeter to individual users and devices.

## 🛡️ Architect's Perspective
In a Zero Trust model, no user or device is implicitly trusted, regardless of their location (inside or outside the corporate network). Security controls must verify both **Identity** (who is access) and **Context** (device health, location, time) during every access request.

### ✅ Checklist for Zero Trust
- [ ] Implement **Identity-Aware Proxy (IAP)** to protect web apps and SSH/RDP access.
- [ ] Use **Context-Aware Access (CAA)** levels to enforce device security requirements.
- [ ] Move from IP-based to **Identity-based firewall rules** using Service Accounts.
- [ ] Ensure all communication is encrypted in transit (TLS/mTLS).

---
*Reference: [GCP Zero Trust Architecture](https://cloud.google.com/architecture/zero-trust-architecture-on-google-cloud)*
