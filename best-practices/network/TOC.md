# Network Security Best Practices: Table of Contents

This directory contains a structured set of Google Cloud network security practices. The guides explain the core concepts, security architecture context, common attacks, implementation patterns, validation evidence, and operational mistakes to avoid.

## Practice list

1. **[Adopt a Zero Trust Network Model](./01-zero-trust-network-model.md)**: identity-aware access, context, segmentation, and moving beyond trusted internal networks.
2. **[Secure Hybrid Connectivity](./02-secure-hybrid-connectivity.md)**: VPN, Interconnect, BGP, route control, encryption, and hybrid attack paths.
3. **[Private Access Options](./03-private-access-options.md)**: Private Google Access, Private Service Connect, private endpoints, DNS, and controlled egress.
4. **[Disable Default Networks and Plan IP Space](./04-disable-default-networks.md)**: default network risk, custom subnet mode, IPAM, and organization policies.
5. **[Network Segmentation and Shared VPC](./05-segmentation-shared-vpc.md)**: workload isolation, host/service projects, trust zones, and blast radius reduction.
6. **[Firewall Hierarchy and Identity-Based Rules](./06-firewall-hierarchy-and-rules.md)**: hierarchical policies, default deny, service account targeting, and firewall evidence.
7. **[Network Analysis, IDS, and Packet Mirroring](./07-network-analysis-ids-mirroring.md)**: what IDS is, what packet mirroring is, Cloud IDS, NDR, and forensic traffic analysis.
8. **[Web Application Firewall and DDoS Protection](./08-web-application-firewall.md)**: what a WAF is, Cloud Armor, OWASP attack patterns, rate limiting, and backend bypass prevention.
9. **[Infrastructure as Code and Security Automation](./09-infrastructure-as-code-automation.md)**: Terraform/OpenTofu, policy-as-code, CI validation, drift, and secure state handling.
10. **[Network Monitoring and Logging](./10-monitoring-and-logging.md)**: VPC Flow Logs, firewall logs, NAT, Cloud Armor, IDS findings, detections, and evidence.

## How to use this section

Start with the network trust model, then design connectivity, private access, segmentation, and firewall guardrails. Add detection and logging after the preventive controls so the organization can prove what is allowed, what is blocked, and what requires investigation.

---
Senior Security Architecture Portfolio
