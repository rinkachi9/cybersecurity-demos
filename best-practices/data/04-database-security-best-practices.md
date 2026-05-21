# 04. Database Security Best Practices

Databases are high-value targets because they usually contain customer records, transactions, application state, business logs, configuration, and sometimes secrets. Protecting them requires IAM, private connectivity, encryption, configuration hardening, backups, and monitoring of access patterns.

## What does database security include?

Database security is more than a SQL password. It includes:

- identity and access control for users and service accounts;
- private connectivity without public exposure;
- TLS for database connections;
- separation of administrative, migration, application, and read-only roles;
- encryption of data, snapshots, and backups;
- application-layer protection against SQL injection;
- audit logging for queries, logins, schema changes, and permission changes;
- tested recovery from backups.

In Google Cloud, this applies to services such as Cloud SQL, AlloyDB, Spanner, Firestore, Bigtable, and BigQuery.

## Architectural context

Database security should be designed from the data flow. An application should have only the permissions required for its bounded context. An infrastructure administrator should not automatically have the right to read production data. An analyst should not use the application service account. A backup should be protected at least as strongly as the source database.

In practice this means:

- separate accounts for applications, migrations, read-only use, administration, and break-glass;
- private access through private IP, Private Service Connect, or the Cloud SQL Auth Proxy;
- no direct database access from the public internet unless there is a controlled exception;
- emergency access with approval and logging;
- Data Access Logs for critical datasets.

## Threats and failure modes this protects against

- **SQL injection** leading to unauthorized read or write operations.
- **Credential stuffing** using leaked database credentials.
- **Public exposure** through public IP addresses and broad firewall rules.
- **Privilege escalation** through excessive database or IAM roles.
- **Lateral movement** from a compromised application into other databases.
- **Ransomware or destructive changes** without a reliable restore path.
- **Unauthorized exports** to external buckets, local files, or analytics environments.

## Implementation guidance for GCP

1. Disable public IP for production databases unless there is a documented exception.
2. Use private IP, Private Service Connect, or the Cloud SQL Auth Proxy.
3. Enforce TLS and certificate validation where supported.
4. Use IAM Database Authentication for Cloud SQL where it fits the operating model.
5. Separate application, migration, read-only, admin, and break-glass identities.
6. Grant permissions at schema, table, view, or dataset level where possible.
7. Enable audit logs for logins, permission changes, exports, and administrative actions.
8. Store database secrets in Secret Manager and rotate them.

## Application security and database security

Hardening the database does not replace secure code. Applications should use:

- parameterized queries;
- an ORM without unsafe string concatenation;
- input validation;
- rate limits and pagination;
- object-level authorization checks.

The database should limit the impact of an application bug. An application account should not be able to create users, disable logging, change IAM, or export an entire dataset unless that is explicitly required.

## Validation and evidence

Useful evidence includes:

- instance configuration showing no public IP;
- connection tests from allowed and blocked networks;
- a user and role inventory with justification;
- Cloud Audit Logs for logins and permission changes;
- successful backup restore test output;
- alerts for unusual reads, exports, failed logins, or privilege changes.

## Common mistakes

- Using one database account for application runtime, migrations, and administration.
- Leaving public IP enabled after a temporary migration.
- Granting schema owner privileges to an application.
- Configuring backups but never testing restore.
- Logging full queries or payloads that contain sensitive data.

## Checklist

- [ ] Production databases are not publicly exposed without a controlled exception.
- [ ] Connections use TLS and a private access path.
- [ ] Database accounts and roles are separated by function.
- [ ] Database secrets are stored in Secret Manager and rotated.
- [ ] Audit logs and alerts cover logins, exports, and permission changes.
- [ ] Backups are tested through a real restore process.

---
Reference: [Cloud SQL security](https://cloud.google.com/sql/docs/mysql/security)
