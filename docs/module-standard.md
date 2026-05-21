# Module Standard

Every demo module should follow a consistent structure. This standard defines readiness criteria for future work and for review as an expert security engineering portfolio.

## Minimal structure

```text
module-name/
  README.md
  metadata.yaml
  runbook.md
  terraform/
    versions.tf
    variables.tf
    main.tf
    outputs.tf
  evidence/
    README.md
  tests/
```

Not every module needs Terraform or tests from the first iteration. If something is missing, the module README should clearly state the current status and the reason.

## Module README

The README should include:

- module purpose;
- business and technical risk;
- threat model or abuse case;
- architecture;
- vulnerable or misconfigured mode, where applicable;
- mitigations;
- run instructions;
- verification steps;
- expected evidence;
- cleanup;
- cost and limitations;
- compliance mapping.

## Metadata

The template is available at [docs/templates/metadata.yaml](./templates/metadata.yaml). Example:

```yaml
id: gcp-cloud-armor-iap-cloud-run
domain: cloud-security
level: advanced
status: planned
estimated_cost: medium
tools:
  - terraform
  - gcloud
  - python
standards:
  - OWASP ASVS
  - NIST CSF
  - CIS GCP Benchmark
controls:
  - WAF
  - IAP
  - least privilege IAM
validation:
  automated: false
  evidence_required: true
```

## Evidence

The template is available at [docs/templates/evidence.md](./templates/evidence.md).

Evidence should be lightweight and free of secrets. Acceptable artifacts include:

- anonymized logs;
- test results;
- BigQuery queries;
- configuration snapshots without sensitive identifiers;
- redacted `gcloud` output;
- expected alert descriptions.

## Terraform

Every Terraform module should include:

- `required_version`;
- `required_providers`;
- variables instead of placeholders;
- variable validation;
- outputs;
- IAM permission notes;
- `plan`, `apply`, and `destroy` instructions;
- cost warning where a paid service is involved.

A module promoted to the productized Terraform baseline must additionally include:

- `terraform.tfvars.example`;
- `examples/minimal`;
- no placeholders such as `YOUR_*`;
- outputs required for pipeline or runbook integration;
- central repository validator coverage for the module.

## Runbook

The template is available at [docs/templates/runbook.md](./templates/runbook.md). A runbook is required for operational modules that involve detection, remediation, access control, or changes that can block an environment.

## Quality gates

Minimal quality gate:

- Python syntax check.
- JavaScript syntax check when `node` is available.
- Markdown local link check.
- Required project file check.
- `metadata.yaml` check for the main list of demo modules.
- `evidence/README.md` and `runbook.md` checks when metadata marks them as required.
- Target state: Terraform fmt/validate, Checkov, TFLint, Trivy, Gitleaks, and ZAP.

## Web workshop baseline

A web security module promoted to the workshop baseline should include:

- vulnerable and secure modes;
- one workshop run path;
- health endpoint;
- automated PoC tests with `vulnerable` and `secure` expectations;
- evidence template for attack and mitigation results;
- central validator coverage for the minimal contract.

## GCP reference architecture baseline

A reference architecture promoted to this baseline should include:

- a complete composition of several security controls, not a single resource;
- Terraform with `versions.tf`, `variables.tf`, `outputs.tf`, and `terraform.tfvars.example`;
- `examples/minimal`;
- architecture diagram as code;
- verification script for security control behavior;
- operational runbook;
- evidence guide;
- central validator coverage for the minimal contract.

## Detection engineering baseline

A detection promoted to this baseline should include:

- one directory per detection;
- `metadata.yaml` with data sources, MITRE ATT&CK mapping, false positives, and tuning;
- `README.md` with logic and limitations;
- `query.sql`;
- `sample-events.json`;
- `expected-result.json`;
- central validator coverage for structure and JSON syntax.

## SOAR dry-run baseline

A SOAR module promoted to this baseline should include:

- deterministic risk scoring;
- remediation defaulting to `dry_run`;
- sample events;
- expected results;
- local dry-run test without a GCP connection;
- central validator coverage for the minimal contract.

## Supply chain baseline

A supply-chain module promoted to this baseline should include:

- pipeline that generates an SBOM;
- vulnerability scan with a result artifact;
- gate blocking high and critical vulnerabilities;
- provenance or example predicate;
- attestation or example payload;
- admission policy;
- evidence guide;
- runbook;
- CODEOWNERS for security-sensitive paths;
- central validator coverage for the minimal contract.

## Portfolio baseline

The portfolio layer should include:

- showcase with 5/30/60/90 minute review paths;
- evidence matrix with proof levels;
- demo script that works without Docker and without GCP;
- quickstart for local validation;
- cost and limitation notes for runtime and cloud modules;
- decision records for key architecture choices;
- central validator coverage for the minimal contract.
