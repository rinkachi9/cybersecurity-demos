# Costs And Limitations

This repository contains local demos, Terraform baselines, and cloud architecture patterns. Some modules reference GCP services that can generate cost if deployed.

## Cost profile

| Area | Cost risk | Notes |
| --- | --- | --- |
| OWASP Top 10 Lab | Low | Local runtime only when run on a developer machine |
| Workload Identity Federation | Low | IAM configuration usually has no direct runtime cost |
| Cloud Armor WAF | Low to medium | Policy, request processing, logging, Adaptive Protection tier, and Load Balancer usage may incur cost |
| Secure Cloud Run Edge | Medium | Load Balancer, Cloud Armor, logging, and Cloud Run usage may incur cost |
| Security Data Lake | Medium | BigQuery storage and scheduled queries may incur cost |
| SOAR Architecture | Low to medium | Workflows, Pub/Sub, Cloud Functions, and logging may incur cost |
| Cloud IDS | High | IDS endpoints can be expensive; keep tests short-lived, mirroring narrow, and teardown evidence mandatory |
| Secure Web Proxy | Medium to high | Gateway and traffic processing can incur cost |
| GKE Security | Medium to high | Cluster runtime cost depends on node/autopilot configuration |
| Supply Chain Security | Low to medium | Cloud Build minutes, Artifact Registry storage, scanners, and logs may incur cost |

## Current limitations

- Terraform modules are maintained as static baselines; deployed validation still requires isolated runtime execution and redacted evidence.
- Runtime evidence is intentionally not committed unless it is redacted and reproducible.
- GCP deployment has not been performed for every module.
- Some controls require organization-level permissions that are not available in every test project.
- Cloud IDS, Secure Web Proxy, VPC Service Controls, and organization policies can disrupt a shared environment if tested without isolation.
- Local JavaScript validation depends on `node` being installed.
- Terraform validation depends on Terraform or OpenTofu being installed.

## Safe deployment constraints

Before deploying a cloud module:

1. Use a dedicated sandbox project.
2. Set budget alerts.
3. Confirm required IAM permissions.
4. Run `terraform plan` and review resource count.
5. Capture redacted evidence.
6. Run cleanup and keep cleanup proof.

## Evidence boundary

The repository should include:

- expected evidence,
- sanitized sample output,
- synthetic events,
- redacted logs,
- dry-run remediation output.

The repository should not include:

- service account keys,
- tokens,
- private project identifiers unless intentionally public,
- customer data,
- non-redacted log exports,
- screenshots containing secrets or personal data.
