# 03. Data Loss Prevention (DLP) and Masking

Sensitive data (PII) must be protected wherever it lives.

## 🛡️ Architect's Perspective
Senior architects use **Cloud DLP** to discover, classify, and protect sensitive data across GCP. Cloud DLP provides automated scanning of GCS, BigQuery, and Cloud SQL, and can mask or anonymize data "on the fly" before it reaches the end user.

### ✅ Checklist for Cloud DLP
- [ ] Implement **Cloud DLP** to automatically scan for PII in GCS buckets.
- [ ] Use **DLP Inspection Templates** to define what data is sensitive (e.g., SSN, Email).
- [ ] Implement **DLP De-identification Templates** to mask or pseudonymize data.
- [ ] Integrate Cloud DLP into your data analytics pipeline (e.g., with BigQuery).

---
*Reference: [GCP Cloud DLP Documentation](https://cloud.google.com/dlp/docs)*
