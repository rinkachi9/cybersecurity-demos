# Detection: Large GCS Data Exfiltration

## Goal

Identify users or service accounts downloading unusually large volumes of Cloud Storage objects.

## ATT&CK Mapping

- T1530: Data from Cloud Storage
- T1041: Exfiltration Over C2 Channel

## Data Sources

- Cloud Audit Logs Data Access.

## Logic

Aggregate `storage.objects.get` operations by actor and bucket over 24 hours. Alert when transferred bytes exceed the threshold.

## False Positives

- Approved migration jobs.
- Disaster recovery restore.
- Analytics exports.

## Tuning

Tune by bucket classification, identity, expected data pipeline schedule, and approved export destinations.

