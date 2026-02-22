# 05. Backup and Disaster Recovery (DR)

Data durability and availability are critical for overall business continuity.

## 🛡️ Architect's Perspective
Senior architects use **Cloud Storage** and **Filestore** with backup and DR capabilities enabled. This includes using **Object Versioning** to protect against accidental deletes, **Cloud Storage Lifecycle Policies** for automated backups, and **Cross-Region Replication** for data durability across regions.

### ✅ Checklist for Backup & DR
- [ ] Implement **Object Versioning** on all critical Cloud Storage buckets.
- [ ] Use **Cloud Storage Lifecycle Policies** to automate backups and data retention.
- [ ] Enable **Cross-Region Replication** for critical data to ensure durability across regions.
- [ ] Regularly test and audit your DR and backup plans.

---
*Reference: [GCP Disaster Recovery](https://cloud.google.com/architecture/disaster-recovery)*
