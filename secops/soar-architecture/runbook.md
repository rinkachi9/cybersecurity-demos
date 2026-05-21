# Runbook: SOAR Leaked Key Response

## Purpose

Use this runbook when a leaked or suspicious service account key finding needs enrichment, decisioning, and possible remediation.

## Preconditions

- Pub/Sub topic accepts SCC-style finding events.
- Workflow is deployed with OIDC access to worker functions.
- Remediation function supports safe test or dry-run execution before production use.

## Trigger

- SCC finding for leaked service account key.
- Manual publication of a test finding to the SOAR topic.
- Detection rule flags suspicious key usage.

## Triage

1. Confirm the resource name and key identifier.
2. Confirm severity and whether the key is actively used.
3. Check recent Audit Logs for source IP, principal, and API methods.
4. Decide whether automatic disablement is safe.

## Response

1. Run enrichment.
2. If risk is critical, disable the key or run dry-run remediation.
3. If risk is medium, create a ticket for analyst approval.
4. Notify the owner and SOC channel.

## Evidence

- Finding payload, redacted.
- Workflow execution ID.
- Enrichment result.
- Remediation result.
- Before and after key state.

## Rollback

If a legitimate key is disabled, create a replacement through approved keyless migration or temporary break-glass procedure. Do not re-enable leaked key material.

