# Runbook: Cloud Armor WAF

## Purpose

Use this runbook to verify that edge traffic is inspected by Cloud Armor and that suspicious requests are logged or blocked.

## Preconditions

- Terraform/OpenTofu is installed for IaC validation.
- Cloud Armor policy is attached to a backend service.
- Test application is exposed through an HTTPS Load Balancer.
- Direct backend access is disabled or intentionally documented.

## Trigger

- WAF verification after deployment.
- Alert for blocked SQLi, XSS, bot, or rate-limit traffic.
- Suspicion that traffic bypasses the load balancer.

## Triage

1. Confirm the backend service has the expected security policy.
2. Confirm the request path went through the load balancer.
3. Check Cloud Logging for `enforcedSecurityPolicy`.
4. Compare rule priority, action, and matched preconfigured expression.

## Response

1. Run the static policy contract check:
   `python3 cloud-security/gcp/network-security/cloud-armor-waf/tests/verify_policy_contract.py`
2. Run `terraform plan` and confirm only the expected policy changes are present.
3. Run the runtime verification script against the load balancer endpoint.
4. Confirm benign requests still succeed.
5. Confirm SQLi, XSS, LFI/path traversal, and RCE probes are denied.
6. Confirm rate-limited traffic returns `429` when threshold is exceeded.
7. Tune exclusions only with documented false-positive evidence.

## Evidence

- Verification script output.
- Terraform validate or plan output with redactions.
- Redacted Cloud Logging query and result.
- Security policy name, rule priority, and action.
- Backend service attachment proof.

## Rollback

1. Switch suspicious new rules to preview mode before removal when possible.
2. If a policy causes outage, detach it from the backend service or revert to the previous policy self link.
3. Keep Cloud Logging evidence showing when the rule started and stopped affecting traffic.
