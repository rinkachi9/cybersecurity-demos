# 09. Infrastructure as Code and Security Automation

Manual infrastructure changes are difficult to review, reproduce, and audit. Infrastructure as Code (IaC) turns cloud configuration into versioned artifacts that can be reviewed, tested, scanned, and promoted through controlled pipelines.

## What is Infrastructure as Code?

**Infrastructure as Code (IaC)** means defining infrastructure resources in code or declarative configuration instead of creating them manually in a console. In Google Cloud, common tools include Terraform, OpenTofu, Deployment Manager legacy configurations, Config Connector, and platform-specific blueprints.

IaC allows teams to:

- review infrastructure changes before deployment;
- enforce security policy in CI/CD;
- reproduce environments consistently;
- detect drift from the desired state;
- connect infrastructure changes to owners, tickets, and approvals.

## Architectural context

Security automation should exist before production resources are deployed. A mature pipeline includes:

- module standards for networks, IAM, logging, and encryption;
- code review for changes to security-sensitive paths;
- static analysis with tools such as Checkov, tfsec, or terrascan;
- formatting and validation checks;
- policy-as-code with OPA, Sentinel, or custom gates;
- plan review before apply;
- controlled state storage and locking.

## Threats and failure modes this protects against

- **Manual misconfiguration** such as public buckets, open firewall rules, or missing logs.
- **Unreviewed IAM changes** deployed directly through the console.
- **Configuration drift** where runtime resources differ from approved code.
- **Inconsistent environments** across projects and teams.
- **Supply-chain risk** from unpinned modules or unreviewed third-party code.
- **No audit trail** for infrastructure changes.

## Implementation guidance for GCP

1. Manage production infrastructure with Terraform, OpenTofu, or another approved IaC tool.
2. Store IaC in version control with CODEOWNERS for security-sensitive paths.
3. Run `fmt`, `validate`, and static security scans in CI.
4. Use reusable modules for networks, IAM, logging, KMS, and common workloads.
5. Keep Terraform state in a protected backend with locking and restricted access.
6. Require plan review for production changes.
7. Detect drift and reconcile it through code, not manual console edits.
8. Pin provider and module versions.

## Security checks worth automating

- no public SSH/RDP from `0.0.0.0/0`;
- no public Cloud Storage buckets unless explicitly approved;
- CMEK required for restricted data;
- required labels and owners;
- logging enabled for critical services;
- no basic IAM roles in production;
- VPC Flow Logs enabled for production subnets;
- no service account key creation in normal workflows.

## Validation and evidence

Useful evidence includes:

- CI output for Terraform format, validation, and security scans;
- pull request review history for infrastructure changes;
- Terraform plan output for production changes;
- state backend access policy;
- drift detection reports;
- policy-as-code rules and exceptions with justification.

## Common mistakes

- Treating IaC as documentation while making real changes in the console.
- Using broad CI/CD service account permissions.
- Not pinning providers or modules.
- Ignoring Terraform state security.
- Not scanning examples and modules used by teams.

## Checklist

- [ ] Production infrastructure is managed through IaC.
- [ ] Security-sensitive paths have CODEOWNERS or required review.
- [ ] CI runs format, validation, and security scans.
- [ ] Providers and modules are pinned.
- [ ] State is protected and access is limited.
- [ ] Drift is detected and remediated through code.

---
Reference: [Google Cloud Architecture Framework - Security](https://cloud.google.com/architecture/framework/security)
