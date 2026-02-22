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
| **Intrusion Detection (DPI)** | **Cloud IDS (Palo Alto Powered)** | SOC2 (Monitor), PCI-DSS (Req 11.4) |
| **Traffic Mirroring (NDR)** | **Packet Mirroring (Custom Analysis)** | PCI-DSS (Req 11.4), SOC2 |
| **Egress Filtering (FQDN)** | **Secure Web Proxy (SWP)** | PCI-DSS (Req 1.2.1), NIST CSF (PR.AC) |
| **Least Privilege (PoLP)** | **Advanced IAM: Custom Roles & Groups** | SOC2 (IAM), PCI-DSS (Req 7.1) |
| **Incident Response** | **Self-Healing Incident Response** | NIST CSF (RS.RP, RS.AN) |

---

## 🏗️ Portfolio Structure

The repository is organized into four main domains:

### 1. Web Security (`/web-security`)
*   **[OWASP Top 10 Lab](./web-security/owasp-top-10/README.md)**: Interactive demo of common vulnerabilities (SQLi, XSS, Broken Access Control) in Node.js with mitigations and Python PoC scripts.

### 2. Google Cloud Security (`/cloud-security/gcp`)
*   **[IAM & Resource Access Management](./cloud-security/gcp/iam-hardening/README.md)**:
    - **[Advanced IAM](./cloud-security/gcp/iam-hardening/resource-access-management/README.md)**: Custom Roles, Group-based access, and the Principle of Least Privilege (PoLP).
    - **[Workload Identity Federation](./cloud-security/gcp/iam-hardening/workload-identity-federation/README.md)**: Keyless CI/CD authentication.
*   **[Governance: Organization Policies](./cloud-security/gcp/governance/README.md)**: Enterprise-wide guardrails enforcing security standards.
*   **[Network Security](./cloud-security/gcp/network-security/README.md)**:
    - **[Cloud Firewall](./cloud-security/gcp/network-security/firewall-policies/README.md)**: Hierarchical Firewall Policies and Identity-based VPC rules.
    - **[Cloud Armor WAF](./cloud-security/gcp/network-security/cloud-armor-waf/README.md)**: L7 protection with Rate Limiting and Adaptive Protection.
    - **[Identity-Aware Proxy (IAP)](./cloud-security/gcp/network-security/zero-trust-iap/README.md)**: Zero Trust Access model with Context-Aware Access.
    - **[VPC Service Controls](./cloud-security/gcp/network-security/vpc-service-controls/README.md)**: Advanced data exfiltration protection and Bridge Perimeters.
    - **[Cloud IDS](./cloud-security/gcp/network-security/cloud-ids/README.md)**: Managed Intrusion Detection & DPI (Palo Alto).
    - **[Packet Mirroring](./cloud-security/gcp/network-security/packet-mirroring/README.md)**: Custom traffic analysis for Network Detection and Response (NDR).
    - **[Secure Web Proxy (SWP)](./cloud-security/gcp/network-security/secure-web-proxy/README.md)**: Managed Egress security and FQDN filtering.
*   **[Incident Response: Self-Healing](./cloud-security/gcp/incident-response/README.md)**: Automated remediation of SCC findings.
*   **[GKE Security: mTLS & Network Policies](./cloud-security/gcp/gke-security/README.md)**: Microservices security using Service Mesh (Istio/ASM).
*   **[Data: Cloud DLP API](./cloud-security/gcp/data-security/cloud-dlp-demo/README.md)**: Automated PII identification and masking.

### 3. DevSecOps & CI/CD (`/devsecops`)
*   **[GitHub Actions Security](./devsecops/github-actions/full-pipeline-demo/README.md)**: "Golden Path" pipeline with Gitleaks, Checkov, and Trivy.
*   **[GitLab CI Security](./devsecops/gitlab-ci/README.md)**: Leveraging native GitLab scanners (SAST, Secret Detection).
*   **[GCP Native: Supply Chain Security](./devsecops/gcp-native-security/README.md)**: Securing the container lifecycle.

---

## 🛠️ Tech Stack
*   **Cloud Platform**: Google Cloud Platform (GCP)
*   **Infrastructure as Code**: Terraform, OpenTofu
*   **Languages**: Python, Node.js, Bash, YAML, SQL, HCL
*   **Security Tools**: Cloud Armor, Cloud IDS, Cloud DLP, IAP, VPC SC, SWP, Istio/ASM, Gitleaks, Checkov, Trivy, OWASP ZAP, Binary Authorization, SCC.

---
*Author: RINKACHI*
