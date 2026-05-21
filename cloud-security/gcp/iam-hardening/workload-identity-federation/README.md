# Workload Identity Federation: Eliminating Static Keys

This module demonstrates keyless authentication from GitHub Actions to Google Cloud. It replaces long-lived service account JSON keys with short-lived OIDC-based credentials restricted to one repository and, by default, the `main` branch.

## Risk

Static service account keys are high-value secrets:

- They can be copied and used outside the CI/CD system.
- They do not expire automatically.
- Rotation is often skipped because it breaks pipelines.
- A leaked key bypasses GitHub repository, branch, and workflow context.

## Security Design

The Terraform module creates:

- Workload Identity Pool for GitHub Actions.
- OIDC provider for `https://token.actions.githubusercontent.com`.
- Attribute mapping for repository, owner, actor, workflow, and ref.
- Attribute condition restricting tokens to the approved repository and refs.
- Automation service account.
- `roles/iam.workloadIdentityUser` binding scoped to the GitHub repository.
- Optional project-level roles for the service account.

## Terraform

Main module:

```bash
cd cloud-security/gcp/iam-hardening/workload-identity-federation/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
terraform output
```

Minimal example:

```bash
cd cloud-security/gcp/iam-hardening/workload-identity-federation/examples/minimal
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

## GitHub Actions

Store Terraform outputs as GitHub repository variables:

- `GCP_WORKLOAD_IDENTITY_PROVIDER` = `workload_identity_provider_name`
- `GCP_SERVICE_ACCOUNT_EMAIL` = `service_account_email`

The workflow must request an OIDC token:

```yaml
permissions:
  contents: read
  id-token: write
```

Use the template in [devsecops/github-actions/templates/gcp-keyless-auth.yml](../../../../devsecops/github-actions/templates/gcp-keyless-auth.yml).

## Validation

Expected checks:

- The GitHub workflow authenticates without JSON keys.
- `attribute_condition` contains the approved repository and refs.
- The service account has no user-managed keys.
- Project roles are limited to the demo's required actions.

## Evidence

Capture redacted evidence in [evidence/README.md](./evidence/README.md):

- `terraform output` values without sensitive data.
- GitHub Actions auth step showing successful OIDC exchange.
- `gcloud auth list` output showing the impersonated service account.
- Proof that no service account key file is stored in GitHub secrets.

## Cleanup

Run `terraform destroy` in the same directory used for deployment. Confirm the service account and workload identity pool are removed from the test project.

---
Reference: [GCP Documentation - Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)
