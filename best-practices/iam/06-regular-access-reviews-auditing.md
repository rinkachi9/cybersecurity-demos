# 06. Regular Access Reviews and IAM Auditing

IAM changes constantly: new projects, teams, incidents, exceptions, migrations, and pipelines. Without regular audit, even a well-designed access model degrades over time.

## What is an access review?

An **access review** is a formal review where a system owner, data owner, or team owner confirms whether a user, group, or service account still needs access. It is not just a generated IAM list. It is a decision: keep, reduce, remove, convert to temporary access, or move to a group.

IAM auditing includes:

- review of high-risk roles;
- detection of unused permissions;
- review of direct grants to human users;
- service account and key review;
- monitoring of IAM policy changes;
- documentation of exceptions.

## Architectural context

A mature access review combines data from several sources:

- Cloud Asset Inventory: who has which roles;
- IAM Recommender: which permissions appear unused;
- Cloud Audit Logs: which identities actually use access;
- the identity provider: who belongs to which group and whether they are still active;
- ticketing and approval systems: why access was granted.

Reviews should be more frequent for production, sensitive data, and administrative roles.

## Threats and failure modes this protects against

- **Privilege creep**: users collect roles over years and team changes.
- **Dormant accounts** retaining access.
- **Insider threat** through access that is no longer required.
- **Large blast radius** when a compromised account has excessive roles.
- **Unauthorized IAM changes** outside approval paths.
- **Lack of compliance evidence** for SOC2, ISO 27001, PCI-DSS, GDPR, or similar frameworks.

## Implementation guidance for GCP

1. Define review frequency, for example monthly for admins and quarterly for standard access.
2. Group reviews by system owner, data owner, or folder owner.
3. Highlight high-risk roles and service accounts.
4. Compare assigned roles with actual usage in logs.
5. Remove direct user grants or move them to groups.
6. Document exceptions with expiration dates.
7. Alert on IAM changes outside the approved process.

## IAM detections worth implementing

- `Owner`, `Editor`, or `Project IAM Admin` granted.
- Service account key created.
- `Service Account Token Creator` granted.
- User from outside the organization domain added.
- IAM policy changed in a production project.
- Break-glass account used.
- Inactive user still has access.

## Validation and evidence

Useful evidence includes:

- access review report with owner decisions;
- list of removed or reduced roles;
- alerts and logs for IAM changes;
- IAM Recommender output before and after remediation;
- exceptions with expiration dates;
- service account inventory with last use and key status.

## Common mistakes

- Treating review as a CSV export without decisions.
- Reviewing users but ignoring service accounts.
- No owner for groups or projects.
- No follow-up after excessive access is found.
- No near real-time detection of IAM changes.

## Checklist

- [ ] Access reviews have owners, frequency, and decision records.
- [ ] High-risk roles are reviewed more often than standard access.
- [ ] IAM Recommender and Audit Logs are used to evaluate actual usage.
- [ ] Direct user grants are removed or justified.
- [ ] IAM changes are alertable.
- [ ] Service accounts, keys, and impersonation are included in reviews.

---
Reference: [IAM Recommender](https://cloud.google.com/iam/docs/recommender-overview)
