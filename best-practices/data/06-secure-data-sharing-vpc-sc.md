# 06. Secure Data Sharing and VPC Service Controls (VPC SC)

Protecting data analytics pipelines is critical for overall organizational security.

## 🛡️ Architect's Perspective
Senior architects use **VPC Service Controls (VPC SC)** to create a secure perimeter around their sensitive data. This protects against data exfiltration, even when identities are compromised. Use **VPC SC Bridges** to securely share data between isolated perimeters (e.g., Production and Analytics).

### ✅ Checklist for Secure Data Sharing
- [ ] Implement **VPC Service Controls (VPC SC)** on all critical projects and datasets.
- [ ] Use **VPC SC Bridges** for secure, cross-perimeter data sharing.
- [ ] Monitor **VPC SC Logs** for suspicious access attempts.
- [ ] Implement **Cloud DLP** for automated PII masking in your data analytics pipelines.

---
*Reference: [GCP VPC Service Controls Overview](https://cloud.google.com/vpc-service-controls/docs/overview)*
