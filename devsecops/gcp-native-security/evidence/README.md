# Evidence: GCP Native Supply Chain

## Expected Evidence

- Cloud Build run ID.
- Immutable image URI and digest.
- Container vulnerability scan result.
- SBOM path or artifact reference.
- SLSA provenance or build predicate reference.
- Binary Authorization attestation result.
- Denied deployment for an unsigned image.
- CODEOWNERS or protected branch evidence for security-sensitive paths.

## Do Not Commit

- Artifact registry credentials.
- Signing keys.
- Private vulnerability reports tied to production images.
