# 02. Use Groups instead of Individual Users

Managing access for individual users is not scalable and leads to "permission sprawl."

## 🛡️ Architect's Perspective
Access should always be granted to **Security Groups** (e.g., `group:dev-team@yourdomain.com`). When a user joins or leaves a team, you update the group membership in your identity provider (Google Workspace, AD), not the IAM policies in GCP.

### ✅ Checklist for Group Management
- [ ] Synchronize your Identity Provider (e.g., Active Directory) with **Google Cloud Identity**.
- [ ] Define RBAC (Role-Based Access Control) groups based on job functions.
- [ ] Ensure that no individual user is granted permissions directly.
- [ ] Audit group memberships regularly to prevent "privilege creep."

---
*Reference: [GCP Group Management](https://cloud.google.com/iam/docs/groups-in-cloud-console)*
