# 03. Data Loss Prevention, Masking, and De-identification

DLP is not a single tool. It is a process for reducing the risk that sensitive data is exposed, copied, logged, exported, or reused in unsafe places. It includes discovery, classification, masking, tokenization, pseudonymization, export control, and incident response.

## What is DLP?

**Data Loss Prevention (DLP)** is a set of controls that detect and protect sensitive data such as email addresses, national identifiers, payment card numbers, health data, customer identifiers, secrets, and tokens.

In Google Cloud, this capability is provided by Sensitive Data Protection, formerly Cloud DLP. It can:

- scan Cloud Storage, BigQuery, and other data sources;
- detect built-in information types such as `EMAIL_ADDRESS`, `CREDIT_CARD_NUMBER`, and `PERSON_NAME`;
- use custom dictionaries, regular expressions, and inspection rules;
- mask, redact, hash, tokenize, or generalize data;
- publish findings to Security Command Center, Pub/Sub, BigQuery, or logs.

## Masking, tokenization, and pseudonymization

- **Masking** hides part of a value, for example `jane.smith@example.com` as `j***@example.com`.
- **Redaction** removes the value completely, often replacing it with `[REDACTED]`.
- **Tokenization** replaces a value with a token that can only be reversed by a controlled system.
- **Pseudonymization** reduces identifiability without additional context or a separate key.
- **Anonymization** removes identifiability in a way that should not be reversible.

## Architectural context

DLP is most effective when it is applied at several points:

- when data enters the organization;
- in the data lake and analytics warehouse;
- before data is shared with BI, ML, or external teams;
- before exports to third-party systems;
- in application and security logs;
- in test environments where production PII should not be copied directly.

DLP should not be treated as a replacement for IAM. If too many users can read the raw dataset, DLP can detect the problem, but it does not fix the access model by itself.

## Threats and failure modes this protects against

- **Accidental PII leakage** in logs, CSV exports, debug output, and reports.
- **Over-sharing analytics data** with teams that only need aggregated data.
- **Secret leakage** in configuration files, buckets, or exported datasets.
- **Data scraping** by an account with legitimate but excessive access.
- **Unsafe test environments** that use production data without masking.
- **Compliance violations** under GDPR, PCI-DSS, HIPAA, SOC2, or similar frameworks.

## Implementation guidance for GCP

1. Define which information types the organization treats as sensitive.
2. Create inspection templates for built-in and custom data types.
3. Create de-identification templates for masking, tokenization, hashing, or redaction.
4. Scan critical BigQuery datasets and Cloud Storage buckets.
5. Publish findings to SCC, Pub/Sub, or BigQuery for reporting and alerting.
6. Automate response: ticket creation, publication block, classification update, or removal.
7. Test false positives and false negatives with synthetic data samples.

## Validation and evidence

Useful evidence includes:

- scan results showing detected sensitive information types;
- sample data before and after de-identification;
- BigQuery reporting queries summarizing findings by data class;
- alerts for assets containing PII without the required classification;
- a negative test where unsafe data is blocked or masked before sharing.

## Common mistakes

- Running a one-time scan instead of continuous or scheduled discovery.
- Not defining custom detectors for organization-specific identifiers.
- Masking data only in the final application while raw data remains widely available.
- Not assigning owners or SLAs to DLP findings.
- Treating pseudonymization as equivalent to anonymization.

## Checklist

- [ ] Sensitive information types and regulatory drivers are documented.
- [ ] Sensitive Data Protection has inspection and de-identification templates.
- [ ] Critical buckets and datasets are scanned regularly.
- [ ] Findings are published to a reportable and alertable destination.
- [ ] Test and analytics data is masked, tokenized, or aggregated.
- [ ] DLP remediation has an owner and SLA.

---
Reference: [Sensitive Data Protection documentation](https://cloud.google.com/sensitive-data-protection/docs)
