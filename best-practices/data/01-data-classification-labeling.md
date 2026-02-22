# 01. Data Classification and Labeling

You cannot protect what you do not know exists. Data classification is the foundation of data security.

## 🛡️ Architect's Perspective
Implement a robust data classification framework that categorizes data based on its sensitivity (e.g., Public, Internal, Confidential, Restricted). Use **GCP Labels** and **Tags** to apply these classifications to resources like Cloud Storage buckets, BigQuery datasets, and Cloud SQL instances.

### ✅ Checklist for Data Classification
- [ ] Define a standard **Data Classification Policy** (e.g., Public, Internal, PII, Secret).
- [ ] Use **GCP Labels** (key-value pairs) to tag resources with their classification.
- [ ] Implement **Cloud DLP** to automatically discover and classify PII in GCS and BigQuery.
- [ ] Restrict access to highly sensitive datasets based on their labels/tags.

---
*Reference: [GCP Data Classification](https://cloud.google.com/architecture/framework/security/data-security)*
