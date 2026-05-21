# Runbook: Workload Identity Federation

## Purpose

Use this runbook to validate or troubleshoot keyless CI/CD authentication to Google Cloud.

## Preconditions

- A dedicated test GCP project.
- Workload Identity Pool and Provider deployed by Terraform.
- CI workflow has `id-token: write`.
- Target service account has only the permissions needed for the demo.

## Trigger

- CI authentication fails.
- A static service account key is found in a pipeline.
- A repository needs migration from JSON keys to OIDC.

## Triage

1. Confirm the repository, branch, and workflow that requested the token.
2. Check the provider attribute mapping and repository claim restriction.
3. Confirm the service account IAM binding uses `roles/iam.workloadIdentityUser`.
4. Check whether any JSON key remains active for the same service account.

## Response

1. Disable or delete static keys after confirming CI can use WIF.
2. Tighten claims to repository, owner, branch, or environment as needed.
3. Run a minimal authenticated `gcloud auth list` step.
4. Capture redacted CI logs as evidence.

## Evidence

- Redacted CI authentication log.
- Workload Identity Provider name.
- Service account email.
- Output showing no active user-managed keys, if available.

## Rollback

Temporarily re-enable a break-glass path only through an approved secret store and time-bound access. Do not commit key material.

