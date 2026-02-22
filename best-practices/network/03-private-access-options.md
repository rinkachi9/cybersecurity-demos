# 03. Leveraging Private Access Options

Accessing Google Cloud APIs and published services should not happen over the public internet. Use private access options for enhanced security.

## 🛡️ Architect's Perspective
By using private access, you ensure that traffic between your VPC and Google's services (like Cloud Storage, BigQuery, Cloud Run) stays within the Google network. This provides enhanced security and reduces exposure to internet-based threats.

### 🚀 Private Access Options
1.  **Private Google Access (PGA)**: For VMs with internal-only IPs to reach Google services.
2.  **Private Service Connect (PSC)**: For accessing Google APIs and published services via internal IP addresses. This is the most modern and granular approach.
3.  **VPC Network Peering**: For connecting two VPCs (use sparingly for scalability).

### ✅ Checklist for Private Access
- [ ] Implement **Private Service Connect (PSC)** for accessing Google APIs (Storage, BigQuery, Pub/Sub).
- [ ] Enable **Private Google Access (PGA)** on all subnets without NAT or Public IPs.
- [ ] Minimize the use of Cloud NAT for internal-only workloads.
- [ ] Audit VPC Peering and move to **Shared VPC** for organizational scalability.

---
*Reference: [GCP Private Access Options](https://cloud.google.com/vpc/docs/private-access-options)*
