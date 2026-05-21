# Runbook: VPC Service Controls

## Purpose

Use this runbook to safely test or operate a VPC Service Controls perimeter around sensitive GCP data services.

## Preconditions

- Dedicated test projects are available.
- Access Context Manager permissions are granted to the operator.
- Perimeter changes are reviewed before enforcement.
- Test identities and test buckets/datasets are used.
- Terraform plan starts with `enforcement_mode = "dry-run"`.

## Trigger

- New sensitive data project enters the perimeter.
- Exfiltration test fails or unexpectedly succeeds.
- User reports access blocked by VPC Service Controls.

## Triage

1. Confirm source identity, source IP, and target resource.
2. Check whether the resource is inside the perimeter.
3. Check access levels and ingress/egress policies.
4. Determine whether the block is intended or an exception is needed.

## Response

1. Run the local Terraform contract check.
2. Review the dry-run `spec` in Terraform plan before applying.
3. Reproduce with a test identity.
4. Capture the denied request and error message.
5. Apply the smallest possible ingress or egress exception.
6. Keep the perimeter in dry-run until denied and allowed paths are reviewed.
7. Enforce only after rollback and exception workflow approval.

## Evidence

- Redacted denied request output.
- Terraform validate or plan output with dry-run spec.
- Access level and perimeter name.
- GCS or BigQuery command used for validation.
- Before and after policy diff.
- Output `dry_run_spec_enabled = true` for non-enforced review.

## Rollback

Revert the perimeter policy to the last known-good version. For critical business impact, move only the affected test resource after approval. For staged tests, switch back to `dry-run` before removing broad exceptions.
