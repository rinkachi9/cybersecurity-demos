# 06. Secure Data Sharing and VPC Service Controls

Modern organizations need to share data across teams, projects, analytics tools, machine learning workflows, and partners. The risk appears when a legitimate identity can export data too broadly or when data leaves the controlled boundary of the organization. VPC Service Controls helps reduce that risk.

## What is VPC Service Controls?

**VPC Service Controls (VPC SC)** creates security perimeters around Google Cloud managed services such as BigQuery, Cloud Storage, Pub/Sub, and Secret Manager. A perimeter restricts which projects and contexts can access protected APIs and where data can be moved.

VPC SC is not a network firewall. It protects managed service API access. It can reduce exfiltration risk even when an attacker has valid credentials but tries to use them from an untrusted context.

## Key concepts

- **Service perimeter**: a boundary that contains projects and protected services.
- **Restricted services**: services protected by the perimeter.
- **Access level**: a condition such as IP range, device posture, region, or identity.
- **Ingress policy**: an exception allowing access into the perimeter.
- **Egress policy**: an exception allowing data to leave to a specific destination.
- **Dry-run mode**: a test mode that reports what would be blocked without enforcing it.
- **Bridge perimeter**: a controlled connection between perimeters.

## Architectural context

VPC SC is especially important for data lakes, BigQuery, ML environments, and analytics pipelines. IAM answers "who can perform this operation." VPC SC adds "from where and across which boundary is this operation allowed."

A safe rollout should be dry-run first. Observe potential violations, define exceptions, test pipelines, and only then enable enforcement. Enabling enforcement too early can break legitimate analytics and backup flows.

## Threats and failure modes this protects against

- **Data exfiltration by a compromised account** used outside a trusted network or project.
- **Copying BigQuery data** into an unauthorized project.
- **Moving Cloud Storage objects** to an external bucket.
- **Abuse of CI/CD tokens** outside the intended environment.
- **Unauthorized SaaS integrations** attempting to read protected APIs.
- **IAM misconfiguration** that would otherwise allow data access.

## Implementation guidance for GCP

1. Identify high-risk data and the projects that process it.
2. Define perimeters for environments such as `prod-data`, `analytics`, and `security`.
3. Enable dry-run and analyze violations in logs.
4. Add access levels for trusted networks, regions, devices, or identities.
5. Add ingress and egress policies only for specific business flows.
6. Test ETL pipelines, BI tools, backups, and external integrations.
7. Move to enforcement only after violations and exceptions are understood.

## Validation and evidence

Useful evidence includes:

- dry-run logs showing potential violations;
- a negative test where access from an untrusted context is blocked;
- a positive test where an approved pipeline works through an explicit exception;
- an exception inventory with owners and business justification;
- a rollback runbook for enforcement mistakes.

## Common mistakes

- Enabling enforcement without dry-run analysis.
- Treating VPC SC as a replacement for IAM.
- Creating broad egress exceptions that bypass the purpose of the perimeter.
- Not monitoring violations after rollout.
- Forgetting administrative tools, backups, and CI/CD pipelines during testing.

## Checklist

- [ ] Critical data projects and services are assigned to a perimeter.
- [ ] Rollout starts in dry-run mode.
- [ ] Access levels and exceptions have owners and justification.
- [ ] Egress is restricted to specific services, projects, and identities.
- [ ] VPC SC violation logs are monitored.
- [ ] A rollback runbook exists before enforcement is enabled.

---
Reference: [VPC Service Controls overview](https://cloud.google.com/vpc-service-controls/docs/overview)
