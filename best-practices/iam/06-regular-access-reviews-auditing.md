# 06. Regular Access Reviews and Auditing

Continuous monitoring is the final piece of a secure IAM strategy.

## 🛡️ Architect's Perspective
Perform regular access reviews to ensure that users only have the permissions they still need. Use **Cloud Audit Logs** and **IAM Recommender** to identify anomalies and over-privileged accounts.

### ✅ Checklist for IAM Auditing
- [ ] Enable **Cloud Audit Logs** (Data Access and Admin Activity) for all projects.
- [ ] Conduct quarterly **Access Reviews** of all high-privilege roles (e.g., Owner, Editor, Admin).
- [ ] Use **IAM Recommender** to automatically identify and remove unused permissions.
- [ ] Set up alerts in **Cloud Monitoring** for suspicious IAM changes (e.g., a new user being added to a highly privileged group).

---
*Reference: [GCP IAM Recommender](https://cloud.google.com/iam/docs/recommender-overview)*
