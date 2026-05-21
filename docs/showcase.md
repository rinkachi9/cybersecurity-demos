# Portfolio Showcase

## Executive summary

`cybersecurity-demos` is an expert security engineering portfolio focused on application security, Google Cloud security architecture, SecOps, and DevSecOps. The repository is structured to show how security controls are designed, validated, monitored, and turned into operational evidence.

The strongest narrative is:

1. A vulnerable application behavior is demonstrated in the OWASP lab.
2. Cloud controls are designed around least privilege, zero trust, and defense in depth.
3. Detection engineering turns telemetry into reviewed alerts.
4. SOAR dry-run response shows controlled remediation without unsafe production action.
5. Supply-chain controls prove that build artifacts can be scanned, described, and admitted only after policy checks.

## Five minute read path

Use this path when the reader needs to understand the project quickly.

1. Start with [Project Assessment](./project-assessment.md) to understand the goal and current maturity.
2. Read [Module Status Matrix](./module-status.md) to see what is already prepared.
3. Open [Evidence Matrix](./evidence-matrix.md) to see what can be proven today.
4. Review the promoted modules:
   - [OWASP Top 10 Lab](../web-security/owasp-top-10/README.md)
   - [Workload Identity Federation](../cloud-security/gcp/iam-hardening/workload-identity-federation/README.md)
   - [Cloud Armor WAF](../cloud-security/gcp/network-security/cloud-armor-waf/README.md)
   - [VPC Service Controls](../cloud-security/gcp/network-security/vpc-service-controls/README.md)
   - [Cloud IDS](../cloud-security/gcp/network-security/cloud-ids/README.md)
   - [Secure Cloud Run Edge](../cloud-security/gcp/reference-architectures/secure-cloud-run-edge/README.md)
   - [Security Data Lake](../secops/security-data-lake/README.md)
   - [SOAR Architecture](../secops/soar-architecture/README.md)
   - [GCP Native Supply Chain Security](../devsecops/gcp-native-security/README.md)

## Thirty minute presentation

Goal: show technical depth without requiring live cloud deployment.

| Time | Topic | Proof |
| --- | --- | --- |
| 0-5 min | Repository operating model and maturity roadmap | `ROADMAP.md`, `docs/module-standard.md` |
| 5-12 min | OWASP lab: exploit expectations and secure mode | PoC script, health endpoint, IDOR scenario |
| 12-20 min | Keyless cloud access and edge controls | WIF Terraform, Cloud Armor WAF Terraform, Cloud Run Edge Terraform, architecture diagram |
| 20-26 min | Detection engineering and SOAR dry-run | Security Data Lake Terraform, detection folders, sample events, expected results, local dry-run test |
| 26-30 min | Supply-chain security | SBOM/SARIF pipeline, provenance, attestation, admission policy |

Recommended local commands:

```bash
python3 scripts/audit/validate_repository.py
python3 secops/soar-architecture/tests/test_dry_run.py
```

## Sixty minute technical walkthrough

Goal: show the full attack -> control -> detection -> response -> evidence chain.

1. Explain the module standard and why every promoted module needs metadata, runbook, evidence, and validation.
2. Walk through OWASP vulnerable versus secure behavior using the PoC expectations.
3. Connect the web risk to cloud architecture controls:
   - external entry through HTTPS Load Balancer,
   - Cloud Armor policy,
   - IAP gate,
   - restricted Cloud Run ingress,
   - least-privilege IAM.
4. Show detection-as-code:
   - brute-force login,
   - low-and-slow beaconing,
   - GCS data exfiltration.
5. Show SOAR dry-run:
   - enrichment,
   - deterministic risk scoring,
   - human approval or remediation recommendation,
   - expected dry-run result.
6. Show supply-chain gate:
   - SBOM generation,
   - SARIF vulnerability output,
   - vulnerability gate before push,
   - Binary Authorization attestation,
   - admission policy.

## Ninety minute expert review

Goal: let a senior reviewer inspect tradeoffs, limitations, and operational readiness.

| Segment | Review focus |
| --- | --- |
| Architecture | Secure Cloud Run Edge, Cloud Armor WAF, VPC Service Controls, Cloud IDS, WIF, IAM minimization, direct ingress prevention |
| AppSec | OWASP lab control design, expected exploit results, secure mode criteria |
| SecOps | detection metadata, false positives, tuning, MITRE mapping, dry-run response |
| DevSecOps | provenance, SBOM, vulnerability gates, CODEOWNERS, no static cloud keys |
| Governance | module standard, roadmap, evidence expectations, quality gate |
| Risks | cost limits, cloud deployment assumptions, placeholder Terraform backlog |

## Interview narrative

The concise narrative is:

> This repository demonstrates how I would turn security concepts into reviewed, testable engineering artifacts. It starts with application abuse cases, then applies cloud-native controls, then creates detection and response paths, and finally secures the delivery pipeline with SBOM, provenance, attestation, and ownership gates.

Use that narrative to keep the conversation anchored in outcomes rather than tool inventory.

## Current readiness

Ready for local review:

- repository quality gate,
- OWASP workshop structure,
- WIF productized Terraform baseline,
- Cloud Armor WAF productized Terraform baseline,
- VPC Service Controls productized dry-run Terraform baseline,
- Cloud IDS productized Terraform baseline,
- Secure Cloud Run Edge Terraform baseline,
- detection-as-code structure,
- Security Data Lake productized Terraform baseline,
- SOAR dry-run test,
- supply-chain policy and evidence structure.

Requires real environment evidence before claiming production validation:

- Terraform validate and plan with installed Terraform/OpenTofu,
- runtime OWASP container evidence,
- deployed Secure Cloud Run Edge evidence,
- Cloud Build provenance and Binary Authorization denial evidence,
- exported screenshots or logs from GCP.
