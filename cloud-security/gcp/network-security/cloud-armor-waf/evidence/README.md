# Evidence: Cloud Armor WAF

## Expected Evidence

- Output from `python3 cloud-security/gcp/network-security/cloud-armor-waf/tests/verify_policy_contract.py`.
- Output from `terraform validate` or OpenTofu equivalent.
- Redacted `terraform plan` showing Cloud Armor policy rules.
- Backend service attachment proof for `security_policy_self_link`.
- Output from `python3 cloud-security/gcp/network-security/cloud-armor-waf/verify_waf.py <LOAD_BALANCER_URL>`.
- Cloud Logging query for denied WAF traffic.
- Security policy rule match for SQLi, XSS, LFI/path traversal, RCE, and rate limiting.
- Proof that direct backend access is not reachable in the target architecture.
- Cleanup proof when the policy is deployed in a paid project.

## Suggested Files

```text
01-policy-contract.txt
02-terraform-validate.txt
03-terraform-plan-redacted.txt
04-backend-attachment-redacted.txt
05-runtime-verifier-output.txt
06-cloud-logging-deny-events-redacted.json
07-cleanup-proof.txt
```

## Do Not Commit

- Public production IPs tied to real systems.
- Full request headers with cookies or bearer tokens.
- reCAPTCHA keys, OAuth secrets, or private backend hostnames.
