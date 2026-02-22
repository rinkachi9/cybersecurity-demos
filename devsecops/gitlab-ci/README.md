# GitLab CI: The All-in-One DevSecOps Platform

GitLab offers one of the most integrated DevSecOps experiences in the market. This module demonstrates how to use GitLab's native features to protect your code.

## 🛡️ Why GitLab CI Security?

1.  **Native Integration**: Security reports are displayed directly in Merge Requests (MRs), making it easy for developers.
2.  **Ultimate vs. Free**: GitLab provides many features in the Ultimate version, but many of them (like SAST or Secret Detection) can be implemented in the Free version using external Docker images (e.g., Trivy, Gitleaks).
3.  **Vulnerability Management**: GitLab allows you to track the status of vulnerabilities (Dismiss, Confirmed, Resolved) directly in the interface.

## 🚀 Key Components in this Demo

### 1. SAST (Static Analysis Security Testing)
- Analyzes source code for flaws (e.g., lack of data validation, weak cryptographic algorithms).
- GitLab automatically detects the language (Python, Node.js, Go) and selects the appropriate scanners.

### 2. Secret Detection
- Blocking commits that contain private keys, API tokens (AWS, GCP, GitHub).

### 3. Dependency & Container Scanning
- Checking libraries (`npm`, \`pip\`) and Docker images for CVEs (Common Vulnerabilities and Exposures).

## 🛠️ How to Implement?
Simply include the appropriate templates in the `.gitlab-ci.yml` file:
```yaml
include:
  - template: Jobs/SAST.gitlab-ci.yml
  - template: Jobs/Secret-Detection.gitlab-ci.yml
```

---
*Reference: [GitLab Security Dashboards](https://docs.gitlab.com/ee/user/application_security/)*
