# 02. Secure Hybrid Connectivity

Hybrid connectivity links on-premises environments, Google Cloud, other clouds, partners, and sometimes branch offices. These links often carry identity traffic, database replication, backups, management access, and production APIs. If they are poorly designed, they become high-value paths for interception, lateral movement, and data exfiltration.

## What is hybrid connectivity?

**Hybrid connectivity** is the set of network paths that connect Google Cloud to external environments. Common patterns include:

- **Cloud VPN / HA VPN**: encrypted IPsec tunnels over the public internet.
- **Dedicated Interconnect**: physical connectivity between the customer network and Google.
- **Partner Interconnect**: connectivity through a supported service provider.
- **Cross-Cloud Interconnect**: private connectivity between Google Cloud and another cloud provider.
- **Network Connectivity Center**: hub-and-spoke connectivity management for hybrid networks.

## Architectural context

Connectivity is not automatically secure because it is private. A private link can still carry malicious traffic, route leaks, overly broad access, and unencrypted application protocols. Hybrid design should include:

- routing controls and BGP prefix filtering;
- encryption at the application layer for sensitive traffic;
- segmentation between environments;
- firewall policies at cloud and on-prem boundaries;
- logging for flow visibility and route changes;
- clear ownership between network, platform, and security teams.

## Threats and failure modes this protects against

- **Man-in-the-middle exposure** when sensitive protocols travel without TLS.
- **Route hijacking or route leaks** through incorrect BGP advertisements.
- **Lateral movement** from on-premises into cloud workloads or the reverse.
- **Data exfiltration** through trusted private links.
- **Single point of failure** from non-redundant tunnels or interconnects.
- **Unmonitored management access** over hybrid paths.

## Connectivity options

| Option | Best for | Security considerations |
| --- | --- | --- |
| HA VPN | encrypted low to medium throughput links | monitor tunnel health and rotate keys |
| Dedicated Interconnect | high throughput and low latency | add MACsec or application encryption where required |
| Partner Interconnect | enterprise connectivity through providers | validate provider controls and redundancy |
| Cross-Cloud Interconnect | private multi-cloud links | segment routes and monitor both clouds |
| Public internet with TLS | low-risk public APIs | do not use for management planes without stronger controls |

## Implementation guidance for GCP

1. Use HA VPN for resilient encrypted connectivity when Interconnect is not required.
2. Use Dedicated or Partner Interconnect for high-volume enterprise traffic.
3. Use redundant attachments, tunnels, routers, and regions for critical paths.
4. Filter BGP advertisements and avoid broad route propagation.
5. Segment hybrid traffic by environment and sensitivity.
6. Encrypt sensitive application traffic with TLS even over private links.
7. Enable logging and monitoring for tunnels, BGP sessions, and flow anomalies.
8. Document allowed protocols and owners for each hybrid path.

## Validation and evidence

Useful evidence includes:

- HA VPN tunnel status and BGP session health;
- route tables showing expected prefixes only;
- firewall rules restricting hybrid source and destination ranges;
- VPC Flow Logs for hybrid traffic;
- failover test results for redundant links;
- TLS configuration for sensitive application protocols.

## Common mistakes

- Treating Interconnect as trusted just because it is private.
- Advertising entire RFC1918 ranges without need.
- Building one VPN tunnel with no redundancy.
- Allowing management protocols from broad on-prem ranges.
- Not monitoring BGP route changes.

## Checklist

- [ ] Hybrid links are redundant for critical workloads.
- [ ] BGP prefixes are filtered and documented.
- [ ] Sensitive application traffic is encrypted.
- [ ] Firewall policies restrict hybrid traffic to required flows.
- [ ] Tunnel, Interconnect, and BGP health are monitored.
- [ ] Failover is tested and documented.

---
Reference: [Choose a Network Connectivity product](https://cloud.google.com/network-connectivity/docs/how-to/choose-connectivity-product)
