# 10. Network Monitoring and Logging

You cannot investigate what you did not record. Network monitoring and logging provide the visibility required to detect attacks, validate controls, troubleshoot connectivity, and produce evidence during incident response.

## What are network monitoring and logging?

Network monitoring measures the state and behavior of network resources. Network logging records events and flows that show what traffic was allowed, denied, routed, or blocked.

Important Google Cloud sources include:

- **VPC Flow Logs**: records sampled network flows for VM traffic.
- **Firewall Rules Logging**: records firewall allow and deny decisions.
- **Cloud NAT logs**: records NAT translations and egress behavior.
- **Load Balancer logs**: records request and backend behavior.
- **Cloud Armor logs**: records WAF and rate limiting decisions.
- **Cloud IDS findings**: records intrusion detection events.
- **Network Intelligence Center**: topology, connectivity tests, and insights.

## Architectural context

Logging should be designed around detection and evidence. Not every log needs the same retention, sampling, or destination. Production, regulated data zones, and internet-facing services usually require stronger logging than low-risk development workloads.

A good design answers:

- which flows must be visible;
- which deny decisions are security-relevant;
- where logs are stored and for how long;
- which alerts are required;
- who can read logs containing sensitive metadata;
- how logs are correlated with IAM and application events.

## Threats and failure modes this detects

- **Port scanning** and reconnaissance.
- **Unexpected outbound connections** to suspicious destinations.
- **Lateral movement** between service tiers.
- **Firewall rule bypass or misconfiguration**.
- **Data exfiltration patterns** such as high-volume egress.
- **DDoS and request floods** at the load balancer or WAF layer.
- **Broken segmentation** where denied traffic starts appearing.

## Implementation guidance for GCP

1. Enable VPC Flow Logs for production subnets with appropriate sampling and metadata.
2. Enable Firewall Rules Logging for critical allow and deny rules.
3. Enable Cloud NAT logs where workloads use NAT egress.
4. Enable load balancer and Cloud Armor logs for public applications.
5. Export security-relevant logs to BigQuery, a SIEM, or a security data lake.
6. Create alerts for unusual egress, denied traffic spikes, and WAF attack spikes.
7. Protect log access because logs can contain sensitive metadata.
8. Define retention according to incident response and compliance needs.

## Useful detections

| Detection | Signal |
| --- | --- |
| Internal port scan | many denied or short-lived flows from one source |
| Unusual egress | new destination country, ASN, or high byte volume |
| Segmentation violation | denied traffic between protected tiers |
| Public attack spike | Cloud Armor blocked request surge |
| NAT abuse | unexpected high-volume NAT translations |
| IDS finding | Cloud IDS high-severity finding in SCC |

## Validation and evidence

Useful evidence includes:

- VPC Flow Logs enabled on production subnets;
- firewall logs for selected allow and deny rules;
- BigQuery or SIEM sink configuration;
- sample queries for suspicious egress and denied traffic;
- alert policy definitions and test alert output;
- retention policy for security logs.

## Common mistakes

- Enabling logs everywhere without retention and cost planning.
- Logging only allow rules and missing denied reconnaissance.
- No central export, leaving logs scattered by project.
- Excessive sampling that hides low-volume attacks.
- Not protecting log readers from sensitive metadata exposure.

## Checklist

- [ ] Production subnets have VPC Flow Logs enabled.
- [ ] Critical firewall allow and deny rules are logged.
- [ ] NAT, load balancer, Cloud Armor, and IDS logs are collected where applicable.
- [ ] Security logs are exported to a central destination.
- [ ] Alerts cover suspicious egress, denied traffic spikes, and WAF/IDS events.
- [ ] Log retention and access controls are documented.

---
Reference: [Network Intelligence Center overview](https://cloud.google.com/network-intelligence-center)
