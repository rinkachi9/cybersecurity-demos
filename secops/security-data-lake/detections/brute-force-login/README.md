# Detection: Brute Force Login Attempts

## Goal

Identify users or source IPs generating many failed authentication or authorization events within one hour.

## ATT&CK Mapping

- T1110: Brute Force

## Data Sources

- Cloud Audit Logs activity table.
- HTTP request metadata where available.

## Logic

Group denied events by principal and source IP. Alert when failures exceed the configured threshold.

## False Positives

- Expired service account credentials.
- CI/CD retry loops.
- Developers testing permissions during incident response.

## Tuning

Start with `failed_attempts > 20` in one hour, then adjust by identity type and source network.

