# Evidence Matrix

This matrix maps each promoted module to the proof that exists now and the proof that should be collected after runtime execution. Evidence must not contain secrets, private keys, tokens, user PII, or unreduced cloud identifiers.

## Evidence levels

| Level | Meaning |
| --- | --- |
| L0 | Concept only, no runnable proof yet |
| L1 | Static proof: files, metadata, IaC, policy, expected output |
| L2 | Local executable proof without cloud deployment |
| L3 | Runtime proof from local container or isolated cloud project |
| L4 | Operational proof: logs, alerts, runbook output, cleanup proof |

## Promoted module evidence

| Module | Current level | Existing proof | Next evidence to collect |
| --- | --- | --- | --- |
| OWASP Top 10 Lab | L1 | Docker/Compose files, secure/vulnerable modes, PoC assertions, IDOR scenario | Local runtime PoC output for vulnerable and secure modes, ZAP baseline output |
| Workload Identity Federation | L1 | Productized Terraform, variables, outputs, GitHub Actions keyless auth template | Terraform validate output, OIDC token exchange evidence with redacted project data |
| Cloud Armor WAF | L2 | Productized Terraform, OWASP preconfigured rules, rate limiting, minimal example, local policy contract test | Terraform validate/plan, backend attachment proof, runtime verifier output, Cloud Logging deny samples |
| VPC Service Controls | L2 | Productized dry-run Terraform, access level, perimeter spec/status, ingress/egress exceptions, minimal example, local contract test | Terraform dry-run plan, denied/allowed access evidence, exfiltration denial, rollback proof |
| Cloud IDS | L2 | Productized Terraform, Service Networking, reserved peering range, IDS endpoint, packet mirroring, minimal example, local contract test | Short-lived Terraform plan/apply evidence, SCC finding, teardown proof |
| Secure Cloud Run Edge | L1 | Terraform baseline, architecture diagram as code, verifier script, runbook | Terraform plan, HTTPS LB/IAP/Cloud Armor runtime checks, direct Cloud Run blocked evidence |
| Security Data Lake | L2 | Productized Terraform, scoped log sinks, dataset IAM, optional scheduled detections, detection manifest, SQL rules, sample events, expected results, local Terraform contract test | Terraform validate/plan, BigQuery scheduled query output, alert rows for synthetic events |
| SOAR Architecture | L2 | Deterministic enrichment/remediation code, sample events, expected results, local dry-run test | Deployed Workflow execution log, approval branch evidence, audit export |
| GCP Native Supply Chain | L1 | Cloud Build supply-chain pipeline, SBOM/SARIF targets, provenance example, attestation payload, admission policy | Cloud Build run artifacts, Binary Authorization allow/deny proof |

## Evidence package structure

Each promoted module should keep evidence in the module-local `evidence/` directory.

Recommended structure:

```text
evidence/
  README.md
  01-local-validation.txt
  02-plan-or-config-redacted.txt
  03-runtime-checks-redacted.txt
  04-alert-or-log-redacted.json
  05-cleanup-proof.txt
```

The exact file names can differ, but every evidence package should answer:

- What was tested?
- Which command or control produced the proof?
- What was the expected result?
- What was the actual result?
- What was redacted?
- What cleanup was performed?

## Cross-domain evidence chain

The expert chain that should be demonstrated end to end is:

1. **Attack**: OWASP PoC shows SQLi, XSS, admin bypass, or IDOR expectation.
2. **Prevent**: Secure mode, WAF, IAP, restricted ingress, least privilege, or admission policy blocks the unsafe path.
3. **Detect**: SQL detection produces an expected finding from synthetic telemetry.
4. **Respond**: SOAR enrichment scores the incident and chooses dry-run remediation or ticket path.
5. **Prove**: Evidence files contain redacted command output, expected result, and cleanup proof.

## Evidence quality rules

- Prefer deterministic text output over screenshots when possible.
- Screenshots are acceptable for cloud console state that has no clean CLI export.
- Every evidence file must be redacted before committing.
- Use synthetic events unless a real dataset is explicitly sanitized.
- Runtime evidence from paid GCP services must include cleanup proof.
- Evidence from failed controls is useful if it includes the fix or next action.
