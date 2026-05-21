# 04. Service Account Management

Service accounts are non-human identities used by applications, pipelines, functions, virtual machines, and managed services. They are frequent attacker targets because they often have persistent access to data and infrastructure.

## What is a service account?

A **service account** in Google Cloud is an identity assigned to a workload, not a person. An application running on Cloud Run, GKE, Compute Engine, or Cloud Functions uses a service account to call Google Cloud APIs.

Important mechanisms include:

- **Attached service account**: a service account assigned to a resource such as a VM or Cloud Run service.
- **Service account impersonation**: controlled use of a service account identity by a user or workload.
- **Service account keys**: static JSON keys; high-risk and usually avoidable.
- **Workload Identity**: keyless identity for workloads such as GKE.
- **Workload Identity Federation**: keyless identity for external workloads and CI/CD.

## Architectural context

A service account should represent one application or one bounded context. A shared `app-prod` account used by many services creates a large blast radius. If one service is compromised, the attacker receives all roles assigned to that account.

A mature model uses:

- separate service accounts per application and environment;
- no static keys unless there is a documented exception;
- minimal roles on specific resources;
- restricted impersonation;
- monitoring for unusual service account usage;
- automatic detection of unused accounts.

## Threats and failure modes this protects against

- **JSON key leakage** in repositories, container images, CI/CD, or laptops.
- **Privilege escalation** through `Service Account Token Creator`.
- **Lateral movement** from a compromised workload into other services.
- **Supply-chain compromise** of a pipeline with production access.
- **Abuse of dormant service accounts** with forgotten roles.
- **Data exfiltration** by an application identity with broad permissions.

## Implementation guidance for GCP

1. Enable organization policies that block service account key creation.
2. Remove or rotate existing keys, starting with production accounts.
3. Use Workload Identity for GKE and attached service accounts for Cloud Run.
4. Use Workload Identity Federation for CI/CD and external systems.
5. Create separate service accounts for applications, environments, and pipelines.
6. Grant roles to service accounts at the specific resource level.
7. Restrict impersonation to approved groups and use cases.
8. Monitor `GenerateAccessToken`, `SignBlob`, `CreateServiceAccountKey`, and unusual usage patterns.

## High-risk roles and permissions

- `roles/iam.serviceAccountTokenCreator`: can mint tokens for a service account.
- `roles/iam.serviceAccountKeyAdmin`: can create and delete keys.
- `roles/iam.serviceAccountUser`: can run resources as a service account.
- `roles/editor` on a service account: usually too broad for application runtime.

## Validation and evidence

Useful evidence includes:

- a service account inventory with active key count;
- organization policy blocking key creation;
- token exchange or impersonation logs;
- a list of accounts unused in the last 90 days;
- alerts for new service account key creation;
- CI/CD output showing WIF without a JSON key.

## Common mistakes

- Storing JSON keys in CI secrets and treating them as safe because they are hidden.
- Reusing one service account across many applications.
- Granting `Editor` to service accounts.
- No alerts for service account key creation.
- Broad impersonation by large developer groups.

## Checklist

- [ ] Service account key creation is blocked by organization policy.
- [ ] CI/CD and external systems use WIF.
- [ ] GCP workloads use attached service accounts or Workload Identity.
- [ ] Service accounts have minimal roles on specific resources.
- [ ] Impersonation is restricted and logged.
- [ ] Unused accounts and keys are regularly removed.

---
Reference: [Service account best practices](https://cloud.google.com/iam/docs/service-account-best-practices)
