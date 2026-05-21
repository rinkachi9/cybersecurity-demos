# Evidence: Workload Identity Federation

## Expected Evidence

- CI log showing OIDC authentication to Google Cloud.
- Redacted `gcloud auth list` output.
- IAM binding showing the repository-scoped principal set.
- Output proving static service account keys are absent or disabled.
- Terraform output for `workload_identity_provider_name`, `service_account_email`, and `attribute_condition`.

## Notes

Prefer short redacted snippets. Never commit JSON service account keys.
