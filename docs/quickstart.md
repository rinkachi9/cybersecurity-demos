# Quickstart

This quickstart prioritizes local review. It does not require Docker, cloud deployment, or paid GCP services.

## Local validation

```bash
python3 scripts/audit/validate_repository.py
```

Expected result:

```text
Repository validation passed.
```

Known local warning:

- JavaScript syntax validation is skipped when `node` is not installed.
- Older Terraform demo modules may still warn about placeholders or missing provider declarations until they are promoted through Stage 3.

## SOAR dry-run

```bash
python3 secops/soar-architecture/tests/test_dry_run.py
```

Expected result:

```text
SOAR dry-run checks passed.
```

## Review-only paths

Use these paths when runtime tools are unavailable:

- AppSec: [OWASP Top 10 Lab](../web-security/owasp-top-10/README.md)
- IAM: [Workload Identity Federation](../cloud-security/gcp/iam-hardening/workload-identity-federation/README.md)
- Edge security: [Cloud Armor WAF](../cloud-security/gcp/network-security/cloud-armor-waf/README.md)
- Data perimeter: [VPC Service Controls](../cloud-security/gcp/network-security/vpc-service-controls/README.md)
- Network detection: [Cloud IDS](../cloud-security/gcp/network-security/cloud-ids/README.md)
- Cloud architecture: [Secure Cloud Run Edge](../cloud-security/gcp/reference-architectures/secure-cloud-run-edge/README.md)
- Detection engineering: [Security Data Lake](../secops/security-data-lake/README.md)
- Response: [SOAR Architecture](../secops/soar-architecture/README.md)
- Supply chain: [GCP Native Supply Chain Security](../devsecops/gcp-native-security/README.md)

## Optional runtime paths

These paths require additional tools and should be run only in an isolated environment:

| Path | Required tools | Notes |
| --- | --- | --- |
| OWASP lab runtime | Docker or Node.js | Use only local test data |
| Terraform validation | Terraform or OpenTofu | Run `fmt` and `validate` before plan |
| GCP architecture deployment | GCP project, billing, Terraform/OpenTofu, gcloud | Collect redacted evidence and cleanup proof |
| Cloud Build supply-chain run | GCP project, Artifact Registry, Cloud Build, Binary Authorization | Collect SBOM, SARIF, provenance, and attestation artifacts |

## Safe review rule

Do not claim runtime validation unless the evidence package contains command output, expected result, actual result, and cleanup proof.
