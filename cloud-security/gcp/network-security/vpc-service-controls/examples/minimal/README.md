# Minimal VPC Service Controls Example

This example creates a dry-run service perimeter spec around one sandbox project.

```bash
terraform init
terraform plan \
  -var="organization_id=123456789012" \
  -var="access_policy_name=accessPolicies/123456789012" \
  -var="protected_project_number=111111111111"
```

Use dry-run first. Do not switch to `enforced` until denied and allowed access tests are reviewed and rollback is approved.
