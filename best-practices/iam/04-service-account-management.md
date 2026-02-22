# 04. Service Account Management

Service accounts are highly privileged and often targeted by attackers. Securing them is critical.

## 🛡️ Architect's Perspective
Avoid creating static JSON service account keys. They are difficult to manage and a high-risk factor for leakage. Instead, use **Workload Identity** (for GKE/Cloud Run) or **Workload Identity Federation** (for external systems) to allow services to authenticate via short-lived tokens.

### ✅ Checklist for Service Accounts
- [ ] Disable the creation of service account keys via **Organization Policies**.
- [ ] Use **Workload Identity** for applications running on GKE and Cloud Run.
- [ ] Rotate existing keys frequently (at least every 90 days) if they must be used.
- [ ] Monitor service account usage logs in **Cloud Audit Logs**.

---
*Reference: [GCP Service Account Best Practices](https://cloud.google.com/iam/docs/service-account-best-practices)*
