# 05. Network Segmentation & Shared VPC

Managing networks project-by-project is not a senior-level practice. Use centralized network management for organizational security.

## 🛡️ Architect's Perspective
**Shared VPC** is the gold standard for enterprise network management. It allows you to centralize VPC management in a host project and isolate workloads into separate service projects. This enhances security, simplifies routing, and enforces consistent firewall policies.

### 🚀 Benefits of Shared VPC
1.  **Centralized Control**: Network administrators manage the host project (VPC, subnets, firewall rules).
2.  **Isolate Workloads**: Developer teams manage applications in service projects without accessing the network layer.
3.  **Governance**: Easier auditing and enforcing organization-level security policies.

### ✅ Checklist for Shared VPC
- [ ] Implement **Shared VPC** for production and staging environments.
- [ ] Enforce **Least Privilege** on IAM for the Host and Service projects.
- [ ] Use **Project Isolation** to prevent lateral movement between workloads in the same VPC.
- [ ] Limit the use of **VPC Peering** in favor of Shared VPC for central control.

---
*Reference: [GCP Shared VPC Overview](https://cloud.google.com/vpc/docs/shared-vpc)*
