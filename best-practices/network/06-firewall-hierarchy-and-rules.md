# 06. Firewall Hierarchy and Identity-based Rules

A multi-level firewall strategy is the core of your defense. Security policies must be enforced at every level of the organization.

## 🛡️ Architect's Perspective
Senior architects create firewall policies and rules at multiple levels: **Organization, Folder, and VPC Network**. This ensures that "Global Guardrails" are enforced for all projects while still allowing granular control for specific applications.

### 🚀 Best Practices for Firewall Configuration
1.  **Identity over IPs**: Move from IP-based rules to **Service Account-based rules**.
2.  **Secure Tags**: Use tags to target specific VM groups (e.g., `web-server`, `database`).
3.  **Default Deny-All**: Enforce a "Default Deny" ingress policy as the baseline.
4.  **Hierarchical Policies**: Create organization-level rules (e.g., block all external SSH) that cannot be overridden by project owners.

### ✅ Checklist for Firewall Setup
- [ ] Implement **Hierarchical Firewall Policies** for all enterprise folders.
- [ ] Enforce a **Default Deny-All** ingress rule on every VPC.
- [ ] Transition from IPs and Tags to **Service Account-based rules**.
- [ ] Regularly audit and clean up unused firewall rules with **Firewall Insights**.

---
*Reference: [GCP Firewall Policies Overview](https://cloud.google.com/firewall/docs/firewall-policies)*
