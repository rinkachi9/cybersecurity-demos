# DevSecOps: Shift-Left Security Pipeline

This module demonstrates a Shift-Left security approach: integrating security testing as early as possible in the software development lifecycle.

## Security pipeline pillars

### 1. Secret scanning with Gitleaks

- **Goal**: detect hardcoded passwords, API keys, certificates, private keys, and tokens.
- **Why it matters**: credential leakage is one of the most common causes of cloud incidents.

### 2. IaC security with Checkov

- **Goal**: scan Terraform and other infrastructure definitions for insecure configuration.
- **Example**: detect public buckets, missing disk encryption, overly broad firewall rules, or unsafe IAM bindings.

### 3. Software Composition Analysis and SAST with Trivy

- **Goal**: detect vulnerabilities in libraries such as `npm` and `pip` packages, container images, and file systems.
- **Why it matters**: application security depends on direct and transitive dependencies as much as on first-party code.

## How to use these tools

The example workflow defines jobs that run on every `push` and `pull_request`.

Good practices:

- **Block on failure**: if a tool finds a critical issue, the pipeline should fail.
- **Visibility**: results should be reported in GitHub Security, uploaded as SARIF, or added to pull request feedback.
- **Ownership**: findings need an owner and remediation SLA.
- **Tuning**: suppressions should be explicit, minimal, and justified.

---
Tools used in this demo: [Gitleaks](https://github.com/gitleaks/gitleaks), [Checkov](https://www.checkov.io/), [Trivy](https://aquasecurity.github.io/trivy/)
