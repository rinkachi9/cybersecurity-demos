# Minimal Cloud Armor WAF Example

This example creates a reusable Cloud Armor policy with Adaptive Protection, rate limiting, and enforced OWASP preconfigured WAF rules.

```bash
terraform init
terraform plan -var="project_id=demo-security-sandbox"
```

The example does not attach the policy to a backend service. Use the `security_policy_self_link` output in a load balancer backend service or a higher-level reference architecture.
