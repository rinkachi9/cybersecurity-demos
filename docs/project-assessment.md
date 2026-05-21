# Project Assessment

## Project goal

`cybersecurity-demos` is a portfolio and lab for advanced web application security, Google Cloud security, DevSecOps, and SecOps. The project demonstrates a Security by Design and Defense in Depth approach through working examples, IaC, automation, and architecture material.

## Current state

The repository currently includes:

- Web Security: an OWASP Top 10 lab in Node.js/Express with vulnerable and secure modes.
- GCP Cloud Security: IAM hardening, Workload Identity Federation, governance, network security, GKE, incident response, and data security.
- SecOps: Security Data Lake in BigQuery, detection SQL, and SOAR based on Workflows, Pub/Sub, and Cloud Functions.
- DevSecOps: GitHub Actions, GitLab CI, and Cloud Build examples.
- Best Practices: material for IAM, network security, and data security.
- Portfolio governance: final acceptance, module standard, status matrix, showcase, evidence matrix, demo script, quickstart, and ADRs.
- Productized reusable controls: Workload Identity Federation, Secure Cloud Run Edge, Cloud Armor WAF, VPC Service Controls, Cloud IDS, Packet Mirroring, Secure Web Proxy, Zero Trust IAP, Cloud DLP, GKE Service Mesh, Organization Policies, Resource Access Management, SOAR, GCP Native Supply Chain, and Security Data Lake baseline.

## Strengths

- Strong domain coverage: application security, cloud, network, IAM, data, CI/CD, and security operations.
- Strong architecture direction: Zero Trust, least privilege, keyless authentication, WAF, VPC SC, DLP, and SOAR.
- Working code examples instead of documentation-only material.
- Compliance mapping in the main README.
- Senior/architect-level portfolio topics: Security Data Lake, GCP-native SOAR, Binary Authorization, Cloud IDS, and Secure Web Proxy.

## Remaining operational gaps

- Some examples still need runtime evidence from an isolated GCP project.
- The OWASP lab has a workshop baseline but still needs ZAP evidence and route-level ASVS mapping.
- Cloud IDS, Secure Web Proxy, GKE, and VPC Service Controls require careful cost and blast-radius testing.
- Runtime supply-chain evidence requires an actual Cloud Build run and Binary Authorization allow/deny proof.

## Recommended development strategy

The best next step is not expanding the scope, but improving evidence quality for existing modules. The project already demonstrates broad competence. The expert level becomes visible when every key module has:

- threat model;
- vulnerable and secured behavior where applicable;
- automated test;
- logs and detections;
- remediation or runbook;
- IaC with validation;
- clear cost and cleanup guidance.

## Technical priority

1. Quality foundation: validator, CI workflow, and module standard.
2. OWASP lab: full workshop maturity.
3. Workload Identity Federation: parameterization and keyless CI.
4. Secure Cloud Run Edge: Zero Trust reference architecture.
5. Security Data Lake and SOAR: detections, sample events, and dry-run remediation.
6. Terraform hardening: providers, variables, examples, Checkov, and TFLint.

## Project risks

- GCP demos can generate cost if modules do not include cleanup and cost notes.
- Controls such as VPC Service Controls, Cloud IDS, and Secure Web Proxy can disrupt a test environment if configured carelessly.
- Missing pinned versions in pipelines can weaken the supply-chain security narrative.

## Current decision

The foundation, standardization, productized Terraform in all `terraform/` directories, web workshop baseline, GCP reference architecture, detection/SOAR baseline, supply-chain baseline, portfolio narrative baseline, and final acceptance are prepared. The highest-value next iterations are runtime evidence collection: run selected modules in isolated environments, collect redacted proof, capture cleanup evidence, and document costs.
