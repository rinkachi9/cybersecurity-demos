# Cloud Armor WAF: Edge Security Policy

This module provides a reusable Google Cloud Armor security policy for HTTP(S) Load Balancer backends. It is designed as a productized Terraform baseline that can be attached to Cloud Run, GKE, Compute Engine, or other compatible backend services.

## Security goal

The policy reduces application-layer risk at the edge before traffic reaches the workload. It focuses on:

- OWASP preconfigured WAF rules for SQL injection, XSS, LFI/path traversal, and RCE probes.
- Source IP rate limiting with optional rate-based ban.
- Optional bot management challenge rule.
- Adaptive Protection for L7 DDoS signal generation.
- Safe rollout through preview mode for selected rules.

## Threat model

| Abuse case | Control |
| --- | --- |
| SQL injection against public endpoints | `sqli-v33-stable` preconfigured WAF rule |
| Reflected or stored XSS probe | `xss-v33-stable` preconfigured WAF rule |
| Path traversal or local file inclusion | `lfi-v33-stable` preconfigured WAF rule |
| Remote command payloads | `rce-v33-stable` preconfigured WAF rule |
| Brute force, scraping, or basic L7 flood | Cloud Armor rate limiting |
| Suspicious automation | Optional bot management challenge |
| L7 DDoS trend | Adaptive Protection |

## Architecture

```text
Internet
  -> Global HTTP(S) Load Balancer
  -> Cloud Armor security policy
  -> Backend service
  -> Cloud Run, GKE, Compute Engine, or other backend
```

For a complete Cloud Run implementation, see [Secure Cloud Run Edge](../../reference-architectures/secure-cloud-run-edge/README.md).

## Terraform baseline

The module is structured as reusable IaC:

```text
terraform/
  versions.tf
  variables.tf
  main.tf
  outputs.tf
  terraform.tfvars.example
examples/
  minimal/
```

Minimal example:

```bash
cd cloud-security/gcp/network-security/cloud-armor-waf/examples/minimal
terraform init
terraform plan -var="project_id=demo-security-sandbox"
```

The module outputs `security_policy_self_link`, which should be attached to a compatible backend service.

## Important variables

| Variable | Purpose |
| --- | --- |
| `policy_name` | Cloud Armor security policy name |
| `enable_adaptive_protection` | Enables L7 DDoS Adaptive Protection |
| `enable_rate_limiting` | Adds source IP throttling |
| `enable_rate_based_ban` | Uses temporary bans instead of only throttling |
| `preconfigured_waf_rules_preview` | Runs OWASP WAF rules in preview mode before enforcement |
| `enable_bot_management` | Adds optional reCAPTCHA bot challenge rule |
| `custom_rules` | Adds additional CEL expressions with explicit priorities |

## Verification

Static local contract check:

```bash
python3 cloud-security/gcp/network-security/cloud-armor-waf/tests/verify_policy_contract.py
```

Runtime WAF check after attaching the policy to a load balancer:

```bash
python3 cloud-security/gcp/network-security/cloud-armor-waf/verify_waf.py https://example-lb.example.com
```

Expected runtime behavior:

- benign request returns `200`,
- SQLi, XSS, path traversal, and RCE probes return `403`,
- aggressive traffic eventually returns `429` if rate limiting is triggered.

## Evidence

Collect evidence in [evidence/](./evidence/README.md):

- `terraform validate` or OpenTofu equivalent output,
- `terraform plan` output with sensitive values redacted,
- backend service attachment proof,
- verifier output,
- Cloud Logging query for denied requests,
- cleanup proof when tested in a paid project.

## Costs and limitations

- Cloud Armor policy configuration is low cost, but request processing, logging, Load Balancer usage, and Adaptive Protection tiering may incur cost.
- Bot management may require Cloud Armor Enterprise and reCAPTCHA Enterprise readiness.
- Preview mode should be used for new custom rules until false positives are understood.
- This module creates the policy only; it does not create the load balancer or backend service.
