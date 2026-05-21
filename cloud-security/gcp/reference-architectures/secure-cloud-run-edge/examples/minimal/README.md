# Minimal Example: Secure Cloud Run Edge

This example composes the Secure Cloud Run Edge Terraform module with a small set of required variables.

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
```

Use a dedicated test project and domain. DNS must point to the emitted load balancer IP before the managed certificate becomes active.

