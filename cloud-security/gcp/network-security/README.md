# Network Security

This area demonstrates layered network protection in Google Cloud: edge security, Zero Trust access, segmentation, egress protection, IDS/NDR, and data exfiltration controls.

## Modules

- [Cloud Armor WAF](./cloud-armor-waf/README.md): productized policy module for L7 WAF, rate limiting, Adaptive Protection, optional bot management, and block verification.
- [Cloud IDS](./cloud-ids/README.md): productized managed IDS baseline with Service Networking, packet mirroring, SCC findings, and cost-aware runbook.
- [Firewall Policies](./firewall-policies/README.md): hierarchical firewall policies and identity-based firewall rules.
- [Packet Mirroring](./packet-mirroring/README.md): NDR and traffic analysis through collector workloads.
- [Secure Web Proxy](./secure-web-proxy/README.md): egress control, FQDN/URL filtering, and TLS inspection.
- [VPC Service Controls](./vpc-service-controls/README.md): productized dry-run first perimeter for data exfiltration protection.
- [Zero Trust IAP](./zero-trust-iap/README.md): Identity-Aware Proxy and context-aware access.

## Expert direction

The target state for this area is a complete Secure Cloud Run Edge reference architecture: Cloud Run, HTTPS Load Balancer, Cloud Armor, IAP, log sink, alerting, and automated tests proving that direct backend access is blocked.
