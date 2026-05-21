# 01. Principle of Least Privilege

Identity is one of the most important security boundaries in cloud environments. The **Principle of Least Privilege (PoLP)** means that a user, group, service account, application, or pipeline should have only the permissions required to perform a specific task.

## What is PoLP?

PoLP is an access design principle that starts with the required action, not with broad roles such as `Owner` or `Editor`. If an application only reads objects from one bucket, it should not administer the whole project. If a team only needs to view logs, it should not be able to change IAM policies.

Google Cloud IAM uses several role types:

- **Basic roles**: `Owner`, `Editor`, and `Viewer`; usually too broad for production.
- **Predefined roles**: service-specific roles such as `roles/logging.viewer`.
- **Custom roles**: roles containing a selected set of permissions.
- **IAM Conditions**: conditional constraints on when or how a role binding applies.

## Architectural context

PoLP is not a one-time cleanup. Permissions naturally grow through projects, incidents, migrations, exceptions, and team changes. A mature IAM model must measure and reduce access continuously:

- access is granted to groups, not individual users;
- roles are granted at the lowest practical resource level;
- administrative access is time-bound;
- service accounts are scoped to one application or workflow;
- IAM Recommender is used to identify unused permissions;
- IAM changes are logged and alertable.

## Threats and failure modes this protects against

- **Privilege escalation**: an attacker uses a broad role to grant themselves more access.
- **Lateral movement**: a compromised account can access many projects or environments.
- **Data exfiltration**: excessive access allows data export outside the intended scope.
- **Destructive operator mistakes**: a team can delete resources because it has admin roles.
- **Service account abuse**: an application with `Editor` becomes a path to project takeover.
- **Compliance failure**: the organization cannot justify why a person has a role.

## Implementation guidance for GCP

1. Block or heavily restrict basic roles in new projects.
2. Grant roles at the lowest practical scope: bucket, dataset, topic, service account, or project.
3. Prefer predefined roles when they match the job.
4. Create custom roles only when predefined roles are too broad.
5. Use IAM Conditions for temporary, environment-specific, or break-glass access.
6. Review IAM Recommender and Policy Analyzer findings regularly.
7. Alert on high-risk role grants such as `Owner`, `Editor`, and `Service Account Token Creator`.

## High-risk roles to review closely

The following roles or capabilities require special control because they can bypass other protections:

- `roles/owner`
- `roles/editor`
- `roles/iam.securityAdmin`
- `roles/resourcemanager.projectIamAdmin`
- `roles/iam.serviceAccountTokenCreator`
- `roles/iam.serviceAccountKeyAdmin`
- administrative roles for KMS, BigQuery, Cloud Storage, and Cloud Build

## Validation and evidence

Useful evidence includes:

- an IAM report showing no basic roles in production projects;
- a list of high-risk role assignments and owners;
- examples of roles granted at resource level instead of project level;
- IAM Recommender output before and after permission reduction;
- an alert or audit log for an IAM change in a production project.

## Common mistakes

- Granting `Editor` because it makes deployment work, then never reducing access.
- Creating custom roles without an owner or review process.
- Granting roles directly to users instead of groups.
- Using the same access model for dev, staging, and production.
- Ignoring indirect access through service account impersonation.

## Checklist

- [ ] Basic roles are removed or formally justified.
- [ ] Roles are granted at the lowest practical resource scope.
- [ ] High-risk roles are monitored and reviewed.
- [ ] IAM Recommender is used to remove unused permissions.
- [ ] Administrative access is time-bound or approval-based.
- [ ] IAM changes are logged and alertable.

---
Reference: [IAM custom roles](https://cloud.google.com/iam/docs/using-iam-custom-roles)
