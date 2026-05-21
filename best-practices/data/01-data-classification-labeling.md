# 01. Data Classification and Labeling

You cannot protect data that the organization cannot identify, locate, or assign to an owner. Data classification is the
first layer of data security because it determines which assets require stronger IAM, encryption, DLP, retention,
logging, monitoring, and approval controls.

## What is data classification?

Data classification is the process of assigning data to sensitivity levels such as `Public`, `Internal`, `Confidential`,
`Restricted`, `PII`, `PCI`, or `Secret`. In practice, this means that a Cloud Storage bucket, BigQuery dataset, Cloud
SQL instance, Pub/Sub topic, or analytics export has a clear business context: what it stores, who owns it, how
sensitive it is, and which compliance requirements apply.

Labeling is the technical implementation of that classification. In Google Cloud, the common mechanisms are:

- `labels`: simple key-value pairs useful for reporting, cost allocation, inventory, and automation.
- `tags`: governance controls that can be integrated with IAM Conditions and organization policies.
- Data Catalog and Dataplex: metadata, lineage, ownership, and governance for analytics environments.
- Sensitive Data Protection: automated discovery of sensitive data types such as PII and secrets.

## Architectural context

In a mature environment, classification is not just documentation. It should drive automated security decisions:

- a resource labeled `restricted` requires CMEK and Data Access Logs;
- a dataset with `pii=true` is scanned by Sensitive Data Protection;
- a project containing regulated data is placed inside a VPC Service Controls perimeter;
- exports from restricted datasets require approval and audit logging;
- backups inherit the classification of the source data.

This turns data security into a system of enforceable rules instead of a set of manual exceptions.

## Threats and failure modes this protects against

- **Shadow data**: unknown copies of data in buckets, temporary tables, CSV exports, and test environments.
- **Public exposure**: accidental publication of a bucket or dataset containing sensitive information.
- **Privilege sprawl**: broad access granted because teams do not know the asset contains PII or financial data.
- **Data exfiltration**: data copied out by a compromised identity, misconfigured pipeline, or uncontrolled export.
- **Compliance failure**: no evidence of where personal data lives, who can access it, and how it is protected.
- **Excessive retention**: sensitive data kept longer than the business or regulatory requirement allows.

## Implementation guidance for GCP

1. Define a central classification model, for example `public`, `internal`, `confidential`, and `restricted`.
2. Assign both a business owner and a technical owner to critical data assets.
3. Require labels for projects, buckets, datasets, database instances, and analytics pipelines.
4. Use tags for security decisions that must be enforced centrally.
5. Scan Cloud Storage and BigQuery with Sensitive Data Protection.
6. Connect DLP findings to alerts, tickets, and remediation workflows.
7. Enable Data Access Logs for high-risk data classes.

## Example classification model

| Class        | Example data                            | Minimum controls                         |
|--------------|-----------------------------------------|------------------------------------------|
| Public       | marketing content, public documentation | no secrets, controlled publication       |
| Internal     | internal docs, operational metrics      | group-based IAM, no public access        |
| Confidential | customer data, financial reports        | least privilege, audit logs, DLP         |
| Restricted   | PII, payment data, secrets, keys        | CMEK, VPC SC, approval, strict retention |

## Validation and evidence

Useful evidence includes:

- an inventory report of resources missing required classification labels;
- Sensitive Data Protection scan results for selected buckets or datasets;
- Cloud Asset Inventory output showing classification coverage;
- organization policy or CI validation requiring labels;
- an alert for a public resource labeled `data_classification=restricted`.

## Common mistakes

- Using labels only for cost reporting and not for security decisions.
- Not assigning a data owner, which leaves retention and access decisions unclear.
- Running one-time classification instead of continuous discovery.
- Labeling an entire project as confidential when individual datasets have different risk levels.
- Not updating the classification when data is copied, transformed, or reused.

## Checklist

- [ ] A formal data classification policy exists.
- [ ] Critical GCP resources have labels or tags that identify data sensitivity.
- [ ] Sensitive Data Protection scans Cloud Storage and BigQuery.
- [ ] Restricted data has stronger IAM, logging, encryption, and retention controls.
- [ ] Resources without classification are reported regularly.
- [ ] Data owners perform access and retention reviews.

---
Reference: [Google Cloud data security framework](https://cloud.google.com/architecture/framework/security/data-security)
