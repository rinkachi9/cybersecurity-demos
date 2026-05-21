# Runbook: Secure Cloud Run Edge

## Purpose

Use this runbook to validate or troubleshoot a Cloud Run service protected by Cloud Armor and IAP behind a global HTTPS Load Balancer.

## Preconditions

- Terraform has deployed the architecture to a dedicated test project.
- DNS for the managed certificate points at the load balancer IP.
- IAP OAuth client exists and is configured for the backend service.
- Test identities are granted `roles/iap.httpsResourceAccessor`.

## Trigger

- New deployment of the reference architecture.
- Suspicion that traffic bypasses Cloud Armor or IAP.
- Alert for WAF deny, IAP deny, or unexpected direct Cloud Run access.

## Triage

1. Confirm the Cloud Run service ingress is internal-and-load-balancer only.
2. Confirm the backend service has the expected Cloud Armor policy attached.
3. Confirm IAP is enabled on the backend service.
4. Confirm only approved identities have IAP access.
5. Check load balancer logs for denied requests and matched policy names.

## Response

1. Run the verification script against the load balancer URL and direct Cloud Run URL.
2. Capture denied direct access to `*.run.app`.
3. Capture unauthenticated IAP denial or redirect.
4. Capture Cloud Armor SQLi/XSS denial evidence.
5. Tune WAF exclusions only with documented false-positive evidence.

## Evidence

- Verification script output.
- Cloud Armor policy name and matching rule priority.
- Backend service IAP setting.
- Cloud Run ingress setting.
- Redacted Cloud Logging query results.

## Rollback

If the edge path breaks legitimate traffic, use a tested previous Terraform plan or disable only the newly introduced rule in preview mode first. Do not change Cloud Run ingress to public as a primary rollback.

