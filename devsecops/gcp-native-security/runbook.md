# Runbook: Secure Container Supply Chain

## Purpose

Use this runbook to validate a container release before it is admitted to a protected runtime.

## Preconditions

- Artifact Registry repository exists.
- Cloud Build service account can push images and write evidence artifacts.
- Binary Authorization attestor exists.
- KMS key version for attestation signing is available.
- Deployment policy requires attestation.

## Trigger

- New container build.
- Vulnerability scan failure.
- Deployment denied by Binary Authorization.
- Missing SBOM or provenance evidence.

## Triage

1. Identify image URI and digest.
2. Locate Cloud Build run ID.
3. Confirm SBOM exists.
4. Review Trivy SARIF summary.
5. Confirm attestation exists for the exact digest.
6. Confirm deployment policy references the expected attestor.

## Response

1. If HIGH/CRITICAL vulnerabilities exist, block release and create remediation ticket.
2. If SBOM is missing, rerun pipeline from a trusted commit.
3. If attestation is missing, verify scan and provenance evidence before signing.
4. If Binary Authorization denies deployment, compare image digest with attested digest.

## Evidence

- Cloud Build ID.
- Image digest.
- SBOM object URI.
- SARIF object URI.
- Attestation resource or payload.
- Admission decision.

## Rollback

Deploy the last known-good attested image digest. Do not bypass the admission policy as a rollback path.

