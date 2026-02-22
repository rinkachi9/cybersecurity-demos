# 05. IAM Conditions and Context-Aware Access

Authentication is just the first step. Authorize access based on the full context of the request.

## 🛡️ Architect's Perspective
Use **IAM Conditions** and **Context-Aware Access (CAA)** to enforce more granular security policies. For example, grant a user access only during their "on-call" hours, or only if they are connecting from a corporate-managed device in a specific country.

### ✅ Checklist for Conditional Access
- [ ] Implement **Time-based IAM Conditions** for temporary or scheduled access.
- [ ] Use **Context-Aware Access** to enforce device security requirements (e.g., encrypted disk, OS version).
- [ ] Restrict access to highly sensitive resources based on **Source IP** or **Geography**.
- [ ] Audit condition matches in **Access Context Manager** logs.

---
*Reference: [GCP IAM Conditions](https://cloud.google.com/iam/docs/conditions-overview)*
