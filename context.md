# Context & Strategy: Cybersecurity Demos Repository

## Project Goal
Create a professional "Showcase" portfolio demonstrating advanced skills in **Web Security** and **Cloud Security (GCP)**. The project aims to show not just theoretical knowledge, but practical implementation of defense mechanisms, automation, and DevSecOps practices.

## Priority Demo Projects (Backlog)

### 1. GCP Keyless Authentication (Workload Identity Federation)
- **Problem**: Storing service account keys (JSON) in CI/CD is a leakage risk.
- **Solution**: Implement Workload Identity Federation for GitHub Actions and GitLab CI.
- **Demo**: Terraform script configuring Pool and Provider, along with a sample workflow for secure GCP resource deployment.
- **Key Aspect**: Supply Chain Security.

### 2. Secure Cloud Run Architecture (Zero Trust & WAF)
- **Components**: Cloud Run (Internal-only), Load Balancer, Cloud Armor, Identity-Aware Proxy (IAP).
- **Description**: Architecture where the app is not publicly accessible without IAP authorization, and traffic is filtered by WAF rules (SQLi, XSS, Geo-blocking).
- **Key Aspect**: Defense in Depth.

### 3. DevSecOps Pipeline "Golden Path"
- **GitHub Actions**: Integration of `gitleaks` (secrets), `checkov` (IaC), `trivy` (scans), and `owasp zap` (DAST).
- **GitLab CI**: Leveraging native security templates with custom policies.
- **Key Aspect**: Shift-Left Security.

### 4. OWASP Top 10 Mitigation Lab (Node.js/Express)
- **Scenarios**:
    - **Broken Access Control**: IDOR demo and proper authorization verification.
    - **Injection**: SQLi vs Parameterized Queries.
    - **Cryptographic Failures**: Password hashing (Argon2/bcrypt) and secure TLS.
- **Key Aspect**: Secure Coding Standards.

## Technical Guidelines
- **IaC First**: Every GCP infrastructure element must be described in Terraform/OpenTofu.
- **Documentation**: Every demo must include a `README.md` file explaining:
    1. What is the risk?
    2. How to reproduce it? (Proof of Concept)
    3. How to mitigate it? (The Fix)
    4. How to automate the testing of this security control?
- **Auditability**: Use Cloud Logging and Cloud Monitoring to show how to detect incidents.

## Quality Standards
- All Python scripts follow PEP8 + typing (mypy).
- Terraform using modules and strict `required_providers` rules.
- No hardcoded secrets—always use Secret Manager or CI/CD environment variables.

---
*Status: In Progress - Structure Initialized*
