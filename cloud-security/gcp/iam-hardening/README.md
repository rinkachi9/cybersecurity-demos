# IAM Hardening

This area demonstrates mature identity and access management in Google Cloud: least privilege, group-based access, workload identities, and elimination of static service account keys.

## Modules

- [Resource Access Management](./resource-access-management/README.md): custom roles, groups, conditional IAM, and granular resource access.
- [Workload Identity Federation](./workload-identity-federation/README.md): keyless CI/CD authentication without JSON service account keys.

## Expert direction

The target state for this area includes:

- parameterized Terraform modules;
- validation of IAM Conditions;
- GitHub and GitLab OIDC examples;
- tests proving that static keys are not required;
- access review runbook;
- mapping to CIS GCP, SOC2, and PCI-DSS.
