# 04. Disable Default Networks & IP Planning

Default configurations are the enemy of security. Always start with a "clean slate" for network resources.

## 🛡️ Architect's Perspective
Default networks are pre-populated with firewall rules that allow SSH/RDP from the entire world. They also use the same IP ranges in every project, leading to inevitable conflicts when connecting projects later.

### 🚀 Best Practices for VPC Configuration
1.  **Skip Default Network**: Use **Organization Policies** to prevent the automatic creation of default networks in new projects.
2.  **Limit VPC Count**: A best practice is to limit the number of VPC networks per project to **one**. This simplifies access control and routing.
3.  **Strategic IP Planning**: Allocate IP ranges across projects and connected deployments to avoid conflicts and ensure efficient routing.

### ✅ Checklist for VPC Setup
- [ ] Implement the **"Skip Default Network"** Org Policy.
- [ ] Create a centralized **IP Address Management (IPAM)** plan for the entire organization.
- [ ] Use **Custom Subnet Mode** for all new VPC networks.
- [ ] Reserve a `/16` or `/20` range for each major workload environment (Prod, Dev, etc.).

---
*Reference: [GCP Organization Policies](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints)*
