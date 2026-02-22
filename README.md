# Cybersecurity Demos: Enterprise Web & Cloud (GCP) 🛡️☁️

**Advanced Security Engineering | Cloud Security Architecture | DevSecOps Automation**

Welcome to the **Cybersecurity Demos** repository. This is a comprehensive portfolio of advanced security solutions for web applications and Google Cloud Platform (GCP) infrastructure. This project demonstrates a **"Security by Design"** and **"Defense in Depth"** approach at a Senior/Architect level.

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
| **Incident Response** | **Self-Healing Incident Response** | NIST CSF (RS.RP, RS.AN) |

---

## 🏗️ Portfolio Structure

The repository is organized into four main domains:

### 1. Web Security (`/web-security`)
*   **[OWASP Top 10 Lab](./web-security/owasp-top-10/README.md)**: Interactive demo of common vulnerabilities (SQLi, XSS, Broken Access Control) in Node.js with mitigations and Python PoC scripts.

### 2. Google Cloud Security (`/cloud-security/gcp`)
*   **[IAM: Workload Identity Federation](./cloud-security/gcp/iam-hardening/workload-identity-federation/README.md)**: Secure CI/CD authentication without static JSON keys.
*   **[Governance: Organization Policies](./cloud-security/gcp/governance/README.md)**: Enterprise-wide guardrails enforcing security standards.
*   **[Network: Cloud Armor WAF](./cloud-security/gcp/network-security/cloud-armor-waf/README.md)**: L7 protection with Rate Limiting for Cloud Run applications.
*   **[Network: Identity-Aware Proxy (IAP)](./cloud-security/gcp/network-security/zero-trust-iap/README.md)**: Zero Trust Access model without a VPN.
*   **[Network: VPC Service Controls](./cloud-security/gcp/network-security/vpc-service-controls/README.md)**: Advanced data exfiltration protection ("Golden Cage").
*   **[Incident Response: Self-Healing](./cloud-security/gcp/incident-response/README.md)**: Automated remediation of SCC findings (e.g., auto-closing public GCS buckets).
*   **[GKE Security: mTLS & Network Policies](./cloud-security/gcp/gke-security/README.md)**: Microservices security using Service Mesh (Istio/ASM).
*   **[Data: Cloud DLP API](./cloud-security/gcp/data-security/cloud-dlp-demo/README.md)**: Automated PII identification and masking.

### 3. DevSecOps & CI/CD (`/devsecops`)
*   **[GitHub Actions Security](./devsecops/github-actions/full-pipeline-demo/README.md)**: "Golden Path" pipeline with Gitleaks, Checkov, and Trivy.
*   **[GitLab CI Security](./devsecops/gitlab-ci/README.md)**: Leveraging native GitLab scanners (SAST, Secret Detection).
*   **[GCP Native: Supply Chain Security](./devsecops/gcp-native-security/README.md)**: Securing the container lifecycle (Artifact Registry Scanning, Binary Authorization).

---

## 🛠️ Tech Stack
*   **Cloud Platform**: Google Cloud Platform (GCP)
*   **Infrastructure as Code**: Terraform, OpenTofu
*   **Languages**: Python, Node.js, Bash, YAML, SQL, HCL
*   **Security Tools**: Cloud Armor, Cloud DLP, IAP, VPC SC, Istio/ASM, Gitleaks, Checkov, Trivy, OWASP ZAP, Binary Authorization, SCC.

---

## 🚀 How to use this repository?
Each module contains a dedicated **`README.md`** file that guides you through:
1.  **Risk Analysis**: Explanation of the attack vector and business impact.
2.  **Defense Strategy**: Rationale behind the defensive mechanisms (e.g., why mTLS over IP-filtering).
3.  **Implementation**: Ready-to-deploy code (IaC / Code).
4.  **Verification**: Instructions on how to verify the security controls.

---
*Author: RINKACHI*
