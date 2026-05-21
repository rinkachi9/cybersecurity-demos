# Detection: Low-and-Slow Network Beaconing

## Goal

Detect workloads communicating with the same external destination at regular intervals.

## ATT&CK Mapping

- T1071: Application Layer Protocol
- T1105: Ingress Tool Transfer

## Data Sources

- VPC Flow Logs.

## Logic

Aggregate source and destination communication by minute. Alert when the destination appears consistently active with low packet-count variability.

## False Positives

- Monitoring agents.
- Software update checks.
- External health checks.

## Tuning

Exclude approved SaaS/API endpoints and internal ranges. Tune `active_minutes` and `packet_variability` per workload.

