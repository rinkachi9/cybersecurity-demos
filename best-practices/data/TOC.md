# Data Security Best Practices: Table of Contents

This directory provides a practical framework for protecting data in Google Cloud. The guides explain core concepts, architectural context, common attacks, implementation patterns, validation evidence, and operational mistakes to avoid.

## Practice list

1. **[Data Classification and Labeling](./01-data-classification-labeling.md)**: how to identify sensitive data, assign owners, and use classification to drive controls.
2. **[Encryption at Rest and in Transit](./02-encryption-at-rest-in-transit.md)**: TLS, CMEK, KMS, separation of duties, and key usage monitoring.
3. **[Data Loss Prevention, Masking, and De-identification](./03-data-loss-prevention-masking.md)**: what DLP is, how to detect PII, and how to reduce data leakage.
4. **[Database Security Best Practices](./04-database-security-best-practices.md)**: private access, IAM, TLS, application accounts, SQL injection, and auditing.
5. **[Backup and Disaster Recovery](./05-backup-disaster-recovery.md)**: RPO, RTO, ransomware, retention, restore testing, and backup protection.
6. **[Secure Data Sharing and VPC Service Controls](./06-secure-data-sharing-vpc-sc.md)**: API perimeters, dry-run rollout, ingress/egress exceptions, and exfiltration control.

## How to use this section

Start by identifying the most important data and where it lives. Then connect classification to encryption, IAM, DLP, backup, and API perimeters. Tools alone are not enough; mature data security requires evidence that controls are working and regularly tested.

---
Senior Security Architecture Portfolio
