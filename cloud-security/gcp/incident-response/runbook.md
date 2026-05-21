# Runbook: Public Bucket Auto-Remediation

## Purpose

Use this runbook when Security Command Center reports public access on a Cloud Storage bucket.

## Preconditions

- SCC notification is configured.
- Pub/Sub topic receives matching findings.
- Remediation function has least-privilege access to update test bucket IAM.
- Dry-run mode is preferred before production enforcement.

## Trigger

- SCC finding category such as `PUBLIC_BUCKET_ACL`.
- Manual test message sent to the remediation topic.

## Triage

1. Confirm bucket name and project.
2. Confirm whether public access is intentional.
3. Check current IAM policy and object ACLs.
4. Identify owner and data classification.

## Response

1. Capture the finding payload.
2. Run remediation in dry-run or test mode.
3. Remove public principals when confirmed.
4. Notify owner and record the before/after state.

## Evidence

- SCC finding ID.
- Function execution ID.
- Before and after IAM policy snippets.
- Owner approval or exception.

## Rollback

If public access was legitimate, restore only the approved principal and document the exception. Prefer signed URLs or controlled sharing over broad public IAM.

