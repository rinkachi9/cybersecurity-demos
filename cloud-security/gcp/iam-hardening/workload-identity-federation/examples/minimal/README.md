# Minimal Example: GitHub Actions WIF

This example shows the smallest safe shape for deploying GitHub Actions Workload Identity Federation.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Replace the project and repository values with a dedicated test project and repository.
3. Run:

```bash
terraform init
terraform plan
terraform apply
terraform output
```

4. Configure GitHub repository variables from the outputs:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`: `workload_identity_provider_name`
- `GCP_SERVICE_ACCOUNT_EMAIL`: `service_account_email`

## Safety

This example grants only `roles/viewer` by default. Replace it with the smallest role needed for the target demo.

