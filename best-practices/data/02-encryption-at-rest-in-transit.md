# 02. Encryption at Rest and In Transit

GCP encrypts all data by default, but enterprise security requires more control.

## 🛡️ Architect's Perspective
Senior architects use **Customer-Managed Encryption Keys (CMEK)** to gain more control over their data's encryption. CMEK allows you to manage keys in **Cloud KMS** and revoke them at any time. For extreme security, use **Customer-Supplied Encryption Keys (CSEK)** to manage keys outside of Google's infrastructure.

### ✅ Checklist for Encryption
- [ ] Implement **CMEK** for high-value datasets in Cloud Storage and BigQuery.
- [ ] Enforce TLS (HTTPS/mTLS) for all data in transit.
- [ ] Use **Cloud KMS** for centralized key management and rotation.
- [ ] Audit key usage in **Cloud Audit Logs**.

---
*Reference: [GCP Encryption at Rest](https://cloud.google.com/docs/security/encryption/at-rest)*
