# Network Security

Ten obszar pokazuje warstwowa ochrone sieci w Google Cloud: edge security, zero trust access, segmentacje, ochrone egress, IDS/NDR i kontrolę eksfiltracji danych.

## Moduly

- [Cloud Armor WAF](./cloud-armor-waf/README.md): productized policy module dla L7 WAF, rate limiting, Adaptive Protection, optional bot management i weryfikacji blokad.
- [Cloud IDS](./cloud-ids/README.md): productized managed IDS baseline z Service Networking, packet mirroring, SCC findings i kosztowym runbookiem.
- [Firewall Policies](./firewall-policies/README.md): hierarchical firewall policies i identity-based firewall rules.
- [Packet Mirroring](./packet-mirroring/README.md): NDR i analiza ruchu przez kolektory.
- [Secure Web Proxy](./secure-web-proxy/README.md): kontrola egress, FQDN/URL filtering i TLS inspection.
- [VPC Service Controls](./vpc-service-controls/README.md): productized dry-run first perimeter dla ochrony przed eksfiltracja danych.
- [Zero Trust IAP](./zero-trust-iap/README.md): Identity-Aware Proxy i context-aware access.

## Kierunek ekspercki

Docelowo ten obszar powinien miec kompletna referencyjna architekture Secure Cloud Run Edge: Cloud Run, Load Balancer, Cloud Armor, IAP, log sink, alerting i automatyczne testy potwierdzajace, ze direct access jest zablokowany.
