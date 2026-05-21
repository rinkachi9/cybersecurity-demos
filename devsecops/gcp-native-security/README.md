# GCP Native DevSecOps: Secure Supply Chain

In modern Cloud Native environments, security does not end with the application code. We must protect the entire **Supply Chain**—from the moment the container is built until it is run in production.

## 🛡️ Three Pillars of Container Security in GCP

### 1. Artifact Registry & Vulnerability Scanning
- **Problem**: Docker images can contain old system libraries with vulnerabilities (CVEs).
- **Solution**: Store images in **Artifact Registry** with **Vulnerability Scanning** enabled. Every `push` automatically triggers a scan, and results are visible directly in the GCP console.

### 2. Binary Authorization ("No Unsigned Code" Principle)
- **Problem**: Someone could manually push an unauthorized or infected image to a GKE cluster.
- **Solution**: **Binary Authorization**. This is an Admission Controller that checks whether an image has been "approved" by your pipeline (e.g., whether it passed security scans). If the image doesn't have the appropriate signature (Attestation), GKE will refuse to run it.

### 3. Cloud Build Security
- **Problem**: CI/CD pipelines can be a weak point (e.g., lack of control over what we're building).
- **Solution**: Use native **Cloud Build**, which integrates with IAP and IAM, eliminating the need for external service account keys.

## 🛠️ How to Implement?
1. Configure **Artifact Registry** using Terraform.
2. Add a scanning step (e.g., **Trivy**) in the `cloudbuild.yaml` file.
3. Enable **Binary Authorization** on GKE/Cloud Run and define a "Require Attestation" policy.

## Supply Chain Baseline

The advanced baseline is defined in [cloud-build/secure-supply-chain.yaml](./cloud-build/secure-supply-chain.yaml). It adds:

- immutable commit-SHA image tagging,
- SPDX JSON SBOM generation,
- Trivy SARIF output,
- HIGH/CRITICAL vulnerability gate,
- Binary Authorization attestation,
- evidence artifact upload.

Supporting policy and evidence examples:

- [Supply chain policy](./policies/admission-policy.yaml)
- [SLSA provenance example](./provenance/slsa-provenance.example.json)
- [Binary Authorization attestation payload example](./attestations/binauthz-attestation-payload.example.json)
- [Runbook](./runbook.md)

---
*Reference: [GCP Binary Authorization Overview](https://cloud.google.com/binary-authorization/docs/overview)*
