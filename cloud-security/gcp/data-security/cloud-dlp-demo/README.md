# Cloud DLP: Protecting Sensitive Data (PII)

In the age of GDPR and increasing privacy requirements, automated identification and protection of sensitive data is a key security engineer's skill.

## 🛡️ What is Cloud DLP?
Cloud DLP (Data Loss Prevention) is a powerful Google Cloud service that can detect, classify, and mask over 150 types of sensitive data (e.g., social security numbers, credit card numbers, email addresses).

## 🚀 Applications in this Demo

1.  **Inspect Template**: Definition of what data we're looking for (e.g., `EMAIL_ADDRESS`, `CREDIT_CARD_NUMBER`).
2.  **De-identify Template**: Definition of how to protect that data (masking with `*`, pseudonymization, or total replacement with the data type).
3.  **Automation**:
    - Scanning GCS Buckets before data analysis.
    - Anonymizing logs before sending them to external SIEM systems.
    - Masking data "on the fly" before displaying it in the UI.

## 🛠️ How to Implement?
1. Define `InspectTemplate` and `DeidentifyTemplate` in Terraform.
2. Call the Cloud DLP API from your application or use existing integrations (e.g., BigQuery, GCS).
3. Monitor "Likelihood" to avoid False Positives.

## 💡 Example Transformations
- **Masking**: `jan.kowalski@gmail.com` -> `j***********i@gmail.com`
- **Pseudonymization**: Replacing data with a token that can be reversed later (Crypto-deterministic format).
- **Bucketing**: Replacing an exact age (e.g., 27) with an age range (20-30 years).

---
*Reference: [GCP Cloud DLP Documentation](https://cloud.google.com/dlp/docs)*
