# 02. Encryption at Rest and in Transit

Encryption reduces the impact of leaked storage media, snapshots, backups, logs, and intercepted communications. Google
Cloud encrypts data by default, but enterprise security often requires stronger control over keys, rotation, separation
of duties, and audit evidence.

## What is encryption at rest and in transit?

**Encryption at rest** protects data stored on disks, in buckets, in databases, in snapshots, and in backups. Examples
include encrypted Cloud Storage objects, BigQuery tables, and Cloud SQL disks.

**Encryption in transit** protects data moving between clients, services, databases, APIs, and networks. It is usually
implemented with TLS, mTLS, or encrypted tunnels.

Common key management models in Google Cloud are:

- Google-managed encryption keys: default encryption managed by Google.
- CMEK: Customer-Managed Encryption Keys stored in Cloud KMS.
- CSEK: Customer-Supplied Encryption Keys provided by the customer.
- Cloud HSM and External Key Manager: keys protected by HSMs or external key systems.

## Architectural context

Encryption does not replace IAM, segmentation, or application authorization. If an attacker has
`bigquery.tables.getData`, disk encryption does not stop the attacker from reading data through the API. Encryption
should be part of a defense-in-depth model:

- IAM controls who can access data.
- KMS controls who can use the encryption key.
- Audit Logs show when a key was used.
- VPC Service Controls restrict where API access can come from.
- DLP reduces unnecessary exposure of sensitive values.

## Threats and failure modes this protects against

- **Network interception** and man-in-the-middle attacks against unencrypted connections.
- **Leaked snapshots or backups** copied outside the controlled environment.
- **Unauthorized infrastructure-level access** without permission to use the KMS key.
- **Storage media compromise** in exceptional infrastructure scenarios.
- **Integration mistakes** that send data over HTTP or fail to validate certificates.
- **Post-contract or post-consent access** where disabling a CMEK key can make data unreadable.

## Implementation guidance for GCP

1. Start with high-risk data: PII, payment data, secrets, security logs, and regulated workloads.
2. Create separate KMS key rings for environments and data domains.
3. Require CMEK for high-value Cloud Storage, BigQuery, Cloud SQL, Pub/Sub, and Artifact Registry assets.
4. Separate resource administration from `cloudkms.cryptoKeyEncrypterDecrypter` permissions.
5. Configure key rotation and document emergency key disablement procedures.
6. Enforce TLS for HTTP services, database connections, and external integrations.
7. Use mTLS when services must authenticate each other, not only encrypt the channel.

## Key management decisions

| Decision             | When to use it                                       | Operational risk                        |
|----------------------|------------------------------------------------------|-----------------------------------------|
| Google-managed keys  | low and medium sensitivity workloads                 | least customer-side control             |
| CMEK                 | regulated data, critical systems, audit requirements | incorrect KMS IAM can break services    |
| CSEK                 | narrow external key custody requirements             | high complexity and data-loss risk      |
| External Key Manager | keys must remain outside Google Cloud                | dependency on external KMS availability |

## Validation and evidence

Useful evidence includes:

- Terraform or resource configuration showing CMEK usage;
- Cloud KMS logs for key use by a specific service account;
- a negative test where removing KMS permission prevents data access;
- TLS or mTLS configuration and connection test output;
- alerts for unexpected KMS key use outside the normal pattern.

## Common mistakes

- Enabling CMEK without a tested recovery and break-glass procedure.
- Granting broad KMS roles to human groups instead of narrow service accounts.
- Letting the same administrators control both data and keys without separation of duties.
- Treating encryption as a fix for excessive IAM permissions.
- Not monitoring `Encrypt`, `Decrypt`, `Sign`, or key administration events.

## Checklist

- [ ] High-risk data has a defined key management model.
- [ ] CMEK is used where required by classification or compliance.
- [ ] KMS access is minimal and separate from resource administration.
- [ ] Key rotation is configured and tested.
- [ ] Production connections use TLS or mTLS.
- [ ] KMS key usage is logged, monitored, and alertable.

---
Reference: [Google Cloud encryption at rest](https://cloud.google.com/docs/security/encryption/at-rest)
