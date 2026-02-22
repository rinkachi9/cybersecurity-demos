# 01. Principle of Least Privilege (PoLP)

Identity is the new perimeter. The core of any IAM strategy is the **Principle of Least Privilege (PoLP)**—giving only the minimum access needed for a specific task.

## 🛡️ Architect's Perspective
Avoid predefined roles like `roles/editor` or `roles/owner`. These are too broad and contain excessive permissions. Instead, use granular, predefined roles (e.g., `roles/compute.networkAdmin`) or create **Custom Roles** when a perfect fit doesn't exist.

### ✅ Checklist for PoLP
- [ ] Use granular, predefined roles wherever possible.
- [ ] Create **Custom Roles** for specific tasks (e.g., security auditors).
- [ ] Grant permissions at the **resource level** (e.g., a specific bucket) rather than the project level.
- [ ] Implement **IAM Recommender** to identify and remove unused permissions.

---
*Reference: [GCP IAM Best Practices](https://cloud.google.com/iam/docs/using-iam-custom-roles)*
