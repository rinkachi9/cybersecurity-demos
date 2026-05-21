# Cybersecurity Demos: Enterprise Web & Cloud (GCP) 🛡️☁️

**Advanced Security Engineering | Cloud Security Architecture | DevSecOps Automation**

Welcome to the **Cybersecurity Demos** repository. This is a comprehensive portfolio of advanced security solutions for web applications and Google Cloud Platform (GCP) infrastructure. This project demonstrates a **"Security by Design"** and **"Defense in Depth"** approach at a Senior/Architect level.

---

## Project Operating Model

This repository is maintained as an executable expert portfolio, not only a documentation collection. The final baseline and quality standards are tracked here:

*   **[Project Assessment](./docs/project-assessment.md)**: current-state analysis, strengths, gaps, risks, and prioritization.
*   **[Module Standard](./docs/module-standard.md)**: target structure and readiness criteria for every demo module.
*   **[Module Status Matrix](./docs/module-status.md)**: current maturity and next expert upgrade for each module.
*   **[Portfolio Showcase](./docs/showcase.md)**: 5/30/60/90 minute presentation paths for technical review.
*   **[Evidence Matrix](./docs/evidence-matrix.md)**: proof levels and the attack -> control -> detection -> response -> evidence chain.
*   **[Demo Script](./docs/demo-script.md)** and **[Quickstart](./docs/quickstart.md)**: dry-run review flow that does not require Docker or GCP deployment.
*   **[Final Acceptance](./docs/final-acceptance.md)**: final static baseline and runtime evidence boundary.
*   **[Decision Records](./docs/decision-records/README.md)**: concise rationale for key architecture choices.

Lightweight validation can be run with:

```bash
python3 scripts/audit/validate_repository.py
```

The validator now checks Python syntax, local Markdown links, Terraform structure, required project files, productized module contracts, detection-as-code, supply-chain artifacts, portfolio documentation, and the baseline module metadata contract.

The first Terraform module promoted to the productized baseline is **[Workload Identity Federation](./cloud-security/gcp/iam-hardening/workload-identity-federation/README.md)**.

The next reusable Terraform control promoted to the productized baseline is **[Cloud Armor WAF](./cloud-security/gcp/network-security/cloud-armor-waf/README.md)**.

The next data-exfiltration control promoted to productized dry-run IaC is **[VPC Service Controls](./cloud-security/gcp/network-security/vpc-service-controls/README.md)**.

The next network detection control promoted to productized IaC is **[Cloud IDS](./cloud-security/gcp/network-security/cloud-ids/README.md)** with Service Networking, packet mirroring, and SCC evidence guidance.

The first web workshop promoted to the automated baseline is **[OWASP Top 10 Lab](./web-security/owasp-top-10/README.md)**.

The first full GCP reference architecture baseline is **[Secure Cloud Run Edge](./cloud-security/gcp/reference-architectures/secure-cloud-run-edge/README.md)**.

The first SecOps baseline promoted to detection-as-code and dry-run response is **[Security Data Lake + SOAR](./secops/security-data-lake/README.md)**.

The next SecOps IaC baseline promoted to productized Terraform is **[Security Data Lake](./secops/security-data-lake/README.md)** with scoped log sinks and optional scheduled detections.

The first supply-chain baseline promoted to SBOM/provenance/attestation is **[GCP Native Supply Chain Security](./devsecops/gcp-native-security/README.md)**.

The portfolio layer promoted in Stage 8 is **[Portfolio Showcase](./docs/showcase.md)** with evidence mapping, demo script, quickstart, cost boundaries, and architecture decision records.

The final static baseline is documented in **[Final Acceptance](./docs/final-acceptance.md)**. Runtime production claims still require redacted evidence from isolated Docker/GCP/Terraform executions.

---

## 🏆 Compliance Mapping (Standards & Compliance)

As a Senior Security Architect, I emphasize aligning technical solutions with specific regulatory and business requirements.

| Security Challenge | Technical Solution | Standard (PCI-DSS, SOC2, GDPR) |
| :--- | :--- | :--- |
| **Sensitive Data Protection** | **Cloud DLP API** (PII Masking) | GDPR (Art. 32), PCI-DSS (Req 3.4) |
| **Data Exfiltration Prevention** | **VPC Service Controls** (Perimeter) | SOC2 (Privacy), NIST CSF (PR.DS) |
| **Internal Traffic Encryption** | **GKE Service Mesh (mTLS)** | PCI-DSS (Req 4.1), HIPAA |
| **Zero Trust Access** | **Identity-Aware Proxy (IAP)** | SOC2 (Access Control), NIST SP 800-207 |
| **Automated Governance** | **Organization Policies** (Guardrails) | CIS GCP Benchmark (v2.0) |
| **Enterprise Firewall** | **Cloud Firewall (Hierarchical Policies)** | PCI-DSS (Req 1.2), NIST CSF (PR.AC) |
| **Intrusion Detection (DPI)** | **Cloud IDS (Palo Alto Powered)** | SOC2 (Monitor), PCI-DSS (Req 11.4) |
| **Traffic Mirroring (NDR)** | **Packet Mirroring (Custom Analysis)** | PCI-DSS (Req 11.4), SOC2 |
| **Egress Filtering (FQDN)** | **Secure Web Proxy (SWP)** | PCI-DSS (Req 1.2.1), NIST CSF (PR.AC) |
| **Least Privilege (PoLP)** | **Advanced IAM: Custom Roles & Groups** | SOC2 (IAM), PCI-DSS (Req 7.1) |
| **Incident Response** | **Self-Healing Incident Response** | NIST CSF (RS.RP, RS.AN) |
| **Detection Engineering** | **Security Data Lake (BigQuery SIEM)** | NIST CSF (DE.AE, DE.CM), SOC2 |
| **Security Automation (SOAR)** | **Event-Driven Workflows** | NIST CSF (RS.RP), SOC2 (Ops) |

---

## 🏗️ Portfolio Structure

The repository is organized into six main domains:

### 1. Web Security (`/web-security`)
*   **[OWASP Top 10 Lab](./web-security/owasp-top-10/README.md)**: Interactive demo of common vulnerabilities (SQLi, XSS, Broken Access Control) in Node.js with mitigations and Python PoC scripts.

### 2. Google Cloud Security (`/cloud-security/gcp`)
*   **[IAM & Resource Access Management](./cloud-security/gcp/iam-hardening/README.md)**: Custom Roles, Group-based access, and the Principle of Least Privilege (PoLP).
*   **[Governance: Organization Policies](./cloud-security/gcp/governance/README.md)**: Enterprise-wide guardrails enforcing security standards.
*   **[Network Security](./cloud-security/gcp/network-security/README.md)**: Cloud Firewall, Cloud Armor WAF, IAP, VPC Service Controls, Cloud IDS, and Packet Mirroring.
*   **[Reference Architectures](./cloud-security/gcp/reference-architectures/README.md)**: End-to-end secure deployment patterns such as Cloud Run behind Load Balancer, Cloud Armor, and IAP.
*   **[Incident Response: Self-Healing](./cloud-security/gcp/incident-response/README.md)**: Automated remediation of SCC findings.
*   **[GKE Security: mTLS & Network Policies](./cloud-security/gcp/gke-security/README.md)**: Microservices security using Service Mesh (Istio/ASM).
*   **[Data: Cloud DLP API](./cloud-security/gcp/data-security/cloud-dlp-demo/README.md)**: Automated PII identification and masking.

### 3. SecOps & Detection Engineering (`/secops`)
*   **[Advanced SOAR Architecture](./secops/soar-architecture/README.md)**: Event-Driven Incident Response using **Google Cloud Workflows**.
*   **[Security Data Lake & Detection Engineering](./secops/security-data-lake/README.md)**: Log aggregation and SQL-based detection rules in **BigQuery**.

### 4. DevSecOps & CI/CD (`/devsecops`)
*   **[GitHub Actions Security](./devsecops/github-actions/full-pipeline-demo/README.md)**: "Golden Path" pipeline with Gitleaks, Checkov, and Trivy.
*   **[GitLab CI Security](./devsecops/gitlab-ci/README.md)**: Leveraging native GitLab scanners (SAST, Secret Detection).
*   **[GCP Native: Supply Chain Security](./devsecops/gcp-native-security/README.md)**: Securing the container lifecycle.

### 5. Best Practices (`/best-practices`)
*   **[Network Security Framework](./best-practices/network/TOC.md)**: A comprehensive set of 10 structured best practices for enterprise GCP network security.
*   **[IAM Security Framework](./best-practices/iam/TOC.md)**: Best practices for managing identities, least privilege, and conditional access.
*   **[Data Security Framework](./best-practices/data/TOC.md)**: Best practices for data classification, encryption, and protection.

---

## 🛠️ Tech Stack
*   **Cloud Platform**: Google Cloud Platform (GCP)
*   **Infrastructure as Code**: Terraform, OpenTofu
*   **Languages**: Python, Node.js, Bash, YAML, SQL, HCL
*   **Security Tools**: Cloud Armor, Cloud IDS, Cloud DLP, IAP, VPC SC, SWP, Istio/ASM, Gitleaks, Checkov, Trivy, OWASP ZAP, Binary Authorization, SCC, Cloud Workflows, BigQuery.

---
*Author: RINKACHI*
