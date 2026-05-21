# 02. Group-Based Access Management

Granting permissions directly to individual users does not scale. It leads to unclear ownership, inconsistent offboarding, and permission sprawl. Groups allow access to be tied to job functions, business ownership, and repeatable review processes.

## What is group-based access management?

Group-based management means that Google Cloud roles are assigned to groups, for example `group:platform-admins@example.com`, instead of directly to people. Membership is managed in a central identity system such as Google Cloud Identity, Google Workspace, Entra ID, Okta, or Active Directory.

Examples:

- `security-auditors@example.com` receives read-only access to logs and configuration;
- `prod-break-glass@example.com` receives emergency access with approval;
- `data-analysts@example.com` receives access to selected BigQuery datasets;
- users are added and removed through HR or ITSM workflows.

## Architectural context

Groups are part of an RBAC model: Role-Based Access Control. Instead of asking "what can Alice do?", the organization asks "what function does this person perform?". Access follows the role, not a long history of individual requests.

In a mature environment, groups are:

- named according to function and environment;
- assigned an owner responsible for membership;
- synchronized from a central identity provider;
- included in regular access reviews;
- combined with IAM Conditions for time-bound or contextual access.

## Threats and failure modes this protects against

- **Permission sprawl**: direct IAM exceptions accumulate over time.
- **Access after role change**: users keep permissions after moving teams.
- **Offboarding gaps**: removing a user from the IdP does not remove manual IAM grants.
- **Poor auditability**: auditors see hundreds of users instead of controlled groups.
- **Permanent temporary access**: incident access is granted and never removed.
- **Large blast radius** from a compromised account with many direct grants.

## Implementation guidance for GCP

1. Define a naming standard such as `gcp-{env}-{domain}-{role}`.
2. Map groups to functions: admin, operator, developer, auditor, and break-glass.
3. Assign Google Cloud roles to groups, not individual users.
4. Synchronize group membership from the central IdP and HR process.
5. Require a group owner and periodic membership attestation.
6. Use separate groups for production and non-production environments.
7. Monitor direct user grants as exceptions.

## Example group model

| Group | Scope | Example roles |
| --- | --- | --- |
| `gcp-prod-viewers@example.com` | production read-only access | Viewer, Logging Viewer |
| `gcp-prod-network-admins@example.com` | production network administration | Compute Network Admin |
| `gcp-security-auditors@example.com` | security review and monitoring | Security Reviewer, Logging Viewer |
| `gcp-break-glass@example.com` | emergency administration | narrow, time-bound admin access |

## Validation and evidence

Useful evidence includes:

- an IAM report showing no direct grants to human users;
- a group inventory with owners and business purpose;
- access review results confirming group membership;
- logs for membership changes in high-risk groups;
- alerts for direct user role grants in production projects.

## Common mistakes

- One generic `developers` group with access to every environment.
- Groups without owners.
- Technical group names that auditors and system owners cannot understand.
- Granting both a group and the same individuals directly.
- No automated removal of membership after a role change.

## Checklist

- [ ] GCP roles are primarily assigned to groups.
- [ ] Direct user grants are exceptions with justification.
- [ ] Groups have owners, descriptions, and access review schedules.
- [ ] Production groups are separate from dev and staging groups.
- [ ] High-risk group membership changes are logged and alertable.
- [ ] Offboarding removes access through the central identity provider.

---
Reference: [Groups in Google Cloud IAM](https://cloud.google.com/iam/docs/groups-in-cloud-console)
