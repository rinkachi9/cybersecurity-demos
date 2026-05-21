# Demo Script

This script gives a repeatable reviewer path through the repository without requiring Docker or GCP deployment.

## Preconditions

- Python 3 is available.
- Docker is optional and not required for this dry-run script.
- GCP credentials are optional and not required for this dry-run script.
- Terraform/OpenTofu is optional for this dry-run script.

## Dry-run demo

Run the repository quality gate:

```bash
python3 scripts/audit/validate_repository.py
```

Expected result:

```text
Repository validation passed.
```

Run the local SOAR dry-run test:

```bash
python3 secops/soar-architecture/tests/test_dry_run.py
```

Expected result:

```text
SOAR dry-run checks passed.
```

## Walkthrough order

### 1. Operating model

Open:

- [Final Acceptance](./final-acceptance.md)
- [Module Standard](./module-standard.md)
- [Module Status Matrix](./module-status.md)

Explain that the repository uses a quality gate and module contract, so security demos are expected to include evidence, metadata, validation, and operational guidance.

### 2. Application abuse case

Open:

- [OWASP Top 10 Lab](../web-security/owasp-top-10/README.md)
- [PoC exploit tests](../web-security/owasp-top-10/tests/poc_exploits.py)

Show that the lab models vulnerable and secure behavior using explicit expectations, including IDOR/Broken Object-Level Authorization.

### 3. Cloud control architecture

Open:

- [Workload Identity Federation](../cloud-security/gcp/iam-hardening/workload-identity-federation/README.md)
- [Cloud Armor WAF](../cloud-security/gcp/network-security/cloud-armor-waf/README.md)
- [Secure Cloud Run Edge](../cloud-security/gcp/reference-architectures/secure-cloud-run-edge/README.md)
- [Cloud Run Edge architecture](../cloud-security/gcp/reference-architectures/secure-cloud-run-edge/architecture.mmd)

Explain how keyless auth, IAP, Cloud Armor, restricted ingress, and least privilege reduce blast radius.

### 4. Detection engineering

Open:

- [Detection manifest](../secops/security-data-lake/detections/manifest.yaml)
- [Brute force detection](../secops/security-data-lake/detections/brute-force-login/README.md)
- [Low-and-slow beaconing detection](../secops/security-data-lake/detections/low-and-slow-beaconing/README.md)
- [GCS exfiltration detection](../secops/security-data-lake/detections/gcs-data-exfiltration/README.md)

Explain the rule structure: metadata, data sources, MITRE mapping, query, sample events, expected result, false positives, and tuning.

### 5. SOAR response

Open:

- [SOAR Architecture](../secops/soar-architecture/README.md)
- [Critical leaked key sample](../secops/soar-architecture/sample-events/leaked-key-critical.json)
- [Critical dry-run expected result](../secops/soar-architecture/expected-results/leaked-key-critical-dry-run.json)

Explain that remediation defaults to dry-run and that deterministic scoring makes local review possible.

### 6. Supply-chain gate

Open:

- [GCP Native Supply Chain Security](../devsecops/gcp-native-security/README.md)
- [Secure supply-chain Cloud Build](../devsecops/gcp-native-security/cloud-build/secure-supply-chain.yaml)
- [Admission policy](../devsecops/gcp-native-security/policies/admission-policy.yaml)

Explain that artifacts need SBOM, scan results, provenance, and attestation before admission.

## Questions to be ready for

| Question | Good evidence |
| --- | --- |
| How do you prove this is not only documentation? | Validator, SOAR dry-run test, PoC assertions, structured Terraform |
| How do you avoid long-lived GCP keys? | Workload Identity Federation module and GitHub Actions OIDC template |
| How do you handle unsafe remediation? | SOAR default dry-run and approval/ticket branch |
| How do you prove artifact integrity? | SBOM, SARIF, provenance example, Binary Authorization attestation |
| What remains before production use? | Runtime evidence, deployed logs, Terraform validation, cost-reviewed cleanup |
