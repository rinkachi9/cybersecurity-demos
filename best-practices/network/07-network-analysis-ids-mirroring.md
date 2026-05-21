# 07. Network Analysis, IDS, and Packet Mirroring

Preventive controls are not enough. Security teams also need visibility into network behavior so they can detect compromise, investigate suspicious traffic, and collect evidence. IDS and packet mirroring provide deeper network visibility than standard logs alone.

## What is an IDS?

An **Intrusion Detection System (IDS)** monitors network or host activity for signs of malicious behavior. Unlike an IPS (Intrusion Prevention System), an IDS usually detects and alerts rather than blocking traffic inline.

An IDS can identify patterns such as:

- malware communication;
- command and control traffic;
- exploit attempts;
- port scanning;
- lateral movement;
- suspicious protocols or payloads;
- known attacker signatures.

**Cloud IDS** is Google Cloud's managed network intrusion detection service. It uses Palo Alto Networks threat detection technology and publishes findings to Security Command Center and Cloud Logging.

## What is packet mirroring?

**Packet Mirroring** copies network packets from selected VM instances, subnets, or network tags and sends them to a collector. The collector can run tools such as Zeek, Suricata, Wireshark, or a commercial NDR platform.

Packet mirroring is useful when teams need deeper packet-level investigation, custom detections, protocol analysis, or forensic capture.

## Architectural context

Cloud IDS and Packet Mirroring are complementary:

- Cloud IDS provides managed signature-based detection with lower operational overhead.
- Packet Mirroring provides raw traffic visibility for custom analysis and forensics.

Both require careful scoping. Mirroring everything is expensive, noisy, and risky because packets may contain sensitive data. Start with critical subnets, high-value workloads, and specific traffic directions.

## Threats and failure modes this detects

- **Command and control** callbacks from compromised workloads.
- **Lateral movement** across subnets or service tiers.
- **Exploit attempts** against exposed services.
- **Data exfiltration** through unusual protocols or destinations.
- **Port scanning** and reconnaissance inside the VPC.
- **Policy bypass** where traffic is allowed but unexpected.

## Implementation guidance for GCP

1. Deploy Cloud IDS for critical subnets or workloads where managed detection is sufficient.
2. Use Packet Mirroring for deep forensic analysis or custom NDR tooling.
3. Scope mirrored traffic by subnet, instance, tag, protocol, CIDR, and direction.
4. Send Cloud IDS findings to Security Command Center and Cloud Logging.
5. Build alert rules for high-severity IDS findings.
6. Protect collectors as sensitive systems because they receive copied traffic.
7. Define retention and redaction rules for packet captures.
8. Document teardown for cost-heavy test deployments.

## IDS versus packet mirroring

| Capability | Cloud IDS | Packet Mirroring |
| --- | --- | --- |
| Managed detection | yes | no |
| Raw packet access | no | yes |
| Custom detection logic | limited | high |
| Operational overhead | lower | higher |
| Forensic packet capture | no | yes |
| Cost and data sensitivity risk | medium | potentially high |

## Validation and evidence

Useful evidence includes:

- Cloud IDS endpoint and monitored subnet configuration;
- SCC finding or Cloud Logging entry for a test event;
- packet mirroring policy with narrow scope;
- collector logs from Zeek, Suricata, or another NDR tool;
- teardown proof for cost-sensitive IDS tests;
- alert configuration for high-severity findings.

## Common mistakes

- Deploying IDS without routing traffic through the monitored path.
- Mirroring too much traffic and overwhelming collectors.
- Capturing sensitive payloads without retention and access controls.
- Treating IDS as a preventive control instead of detection.
- Ignoring false positives and tuning requirements.

## Checklist

- [ ] Critical network zones have a detection strategy.
- [ ] Cloud IDS or packet mirroring scope is narrow and documented.
- [ ] IDS findings are sent to SCC, logs, or a SIEM.
- [ ] Packet collectors are secured and monitored.
- [ ] Alerts exist for high-severity findings.
- [ ] Cost and teardown guidance is documented.

---
Reference: [Cloud IDS overview](https://cloud.google.com/cloud-ids/docs)
