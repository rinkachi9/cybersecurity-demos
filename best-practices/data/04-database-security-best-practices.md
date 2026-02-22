# 04. Database Security Best Practices

Securing SQL and NoSQL databases is critical to overall application security.

## 🛡️ Architect's Perspective
Senior architects use **Cloud SQL** and **Cloud Spanner** with centralized security management. This includes using **Cloud SQL Proxy** to avoid public IP addresses, enforcing **TLS** for all database connections, and using **IAM Database Authentication** to simplify user management.

### ✅ Checklist for Database Security
- [ ] Implement **Cloud SQL Proxy** or **Private Service Connect (PSC)** for secure, private database access.
- [ ] Enforce **TLS** on all database connections.
- [ ] Use **IAM Database Authentication** for centralized user management.
- [ ] Monitor database logs in **Cloud Logging** for suspicious activity.

---
*Reference: [GCP Cloud SQL Security](https://cloud.google.com/sql/docs/mysql/security)*
