# Module Status Matrix

This matrix shows what is already prepared and what remains to make each module operationally credible at expert review level.

| Area | Module | Current State | Expert Upgrade |
| --- | --- | --- | --- |
| Web Security | OWASP Top 10 Lab | Workshop baseline with Docker/Compose files, secure/vulnerable modes, IDOR scenario, automated PoC assertions | OWASP ASVS mapping, ZAP baseline scan, runtime evidence capture |
| IAM | Resource Access Management | Productized Terraform baseline with custom role, group binding, bucket-level IAM, conditional temporary access, variables and outputs | IAM policy tests, access review runbook, sandbox evidence |
| IAM | Workload Identity Federation | Productized Terraform baseline, minimal example, GitHub Actions variables template | GitLab OIDC variant, no-static-key verification, Terraform CI validation |
| Governance | Organization Policies | Productized Terraform baseline for organization guardrails: service account keys, public IP, bucket access, default VPC, resource locations | dry-run rollout evidence, exception process |
| Network | Cloud Armor WAF | Productized Terraform baseline with OWASP preconfigured rules, rate limiting, optional bot management, Adaptive Protection, outputs, minimal example, runbook and local contract test | Runtime WAF evidence, backend attachment proof, log-based alerts |
| Network | Zero Trust IAP | Productized Terraform baseline with Context-Aware Access level, conditional IAP IAM, optional bridge perimeter | authenticated/unauthenticated access tests, device context evidence |
| Network | VPC Service Controls | Productized dry-run first Terraform baseline with access level, service perimeter, ingress/egress exceptions, minimal example, contract test, runbook and evidence guide | Runtime denied/allowed evidence, exception workflow proof, rollback drill |
| Network | Cloud IDS | Productized Terraform baseline with Service Networking, reserved peering range, IDS endpoint, packet mirroring, minimal example, contract test, runbook and evidence guide | Short-lived runtime evidence, SCC finding proof, teardown evidence |
| Network | Packet Mirroring | Productized Terraform baseline with collector ILB, health check, packet mirroring scope and collector firewall rule | Suricata/Zeek collector, sample detections, packet evidence |
| Network | Secure Web Proxy | Productized Terraform baseline with URL lists, gateway policy rule, optional TLS inspection and optional Firewall Plus IPS rule | allow/deny egress tests, TLS inspection runtime evidence |
| Reference Architecture | Secure Cloud Run Edge | Terraform baseline with Cloud Run, HTTPS Load Balancer, Cloud Armor, IAP, restricted ingress, evidence and runbook | Runtime evidence from test project, alert policies, DNS/certificate operational notes |
| GKE | Network Policies and Mesh | Productized Terraform baseline for Workload Identity and Dataplane V2 cluster plus mesh enable guidance | workload sample, mTLS verification, policy tests |
| Data | Cloud DLP | Productized Terraform baseline for inspect and de-identification templates | real API path, test data, de-identification evidence |
| SecOps | Security Data Lake | Productized Terraform and detection-as-code baseline with scoped log sinks, BigQuery dataset IAM, optional scheduled queries, metadata, SQL, sample events, expected results, MITRE mapping | Terraform plan evidence, deployed scheduled query proof, local synthetic query tests |
| SecOps | SOAR Architecture | Productized Terraform and deterministic dry-run response baseline with enrichment, remediation, workflow, sample events and local dry-run test | Deployed Workflow evidence, human approval integration, audit trail export |
| DevSecOps | GitHub Actions Pipeline | security scanner workflow sample | pinned actions, SARIF upload, branch protection, OIDC deploy |
| DevSecOps | GitLab CI Pipeline | security template sample | policy gates, artifacts, severity thresholds |
| DevSecOps | GCP Native Supply Chain | Productized Terraform plus SBOM/provenance/attestation baseline with Cloud Build, admission policy, examples, runbook and CODEOWNERS | Real Cloud Build evidence, Binary Authorization denial evidence, branch protection screenshot/export |

## Status legend

- Current State: what is present in the repository now.
- Expert Upgrade: the next concrete step that makes the module operationally credible.

## Stage 2 baseline

All modules in this matrix now have `metadata.yaml` with domain, level, status, tools, standards, controls, validation status, and next upgrade steps. They also have `evidence/README.md`, so every module has an explicit place for redacted proof.

The first operational runbook baseline exists for:

- Workload Identity Federation.
- Cloud Armor WAF.
- Security Data Lake.
- SOAR Architecture.
- VPC Service Controls.
- Public bucket incident response.

Remaining modules keep runbooks optional until they are promoted into active operational scenarios.

## Stage 8 baseline

Portfolio readiness is now tracked as a first-class layer:

- [Portfolio Showcase](./showcase.md) defines 5/30/60/90 minute review paths.
- [Evidence Matrix](./evidence-matrix.md) maps promoted modules to proof levels and next evidence.
- [Demo Script](./demo-script.md) gives a no-Docker, no-GCP dry-run walkthrough.
- [Quickstart](./quickstart.md) lists local validation and optional runtime paths.
- [Costs And Limitations](./costs-and-limitations.md) documents cost risk and safe deployment constraints.
- [Decision Records](./decision-records/README.md) explain the architecture choices behind the portfolio.

The central validator checks this portfolio baseline so the narrative layer remains consistent with the technical artifacts.

## Final static baseline

All Terraform directories now have:

- `main.tf`;
- `versions.tf`;
- `variables.tf`;
- `outputs.tf`;
- declared `required_providers`;
- no `YOUR_*`, `yourdomain.com`, or `your-` placeholders.

Runtime evidence remains intentionally separate: modules that require Docker, Terraform CLI, Cloud Build, or GCP deployment must collect redacted evidence before any production-validation claim.
