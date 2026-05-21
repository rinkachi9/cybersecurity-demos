# Supply Chain Security Baseline

This baseline turns the container path into an evidence-producing gate:

1. Build an immutable image tagged with `$COMMIT_SHA`.
2. Generate an SPDX JSON SBOM.
3. Run vulnerability scanning and produce SARIF.
4. Fail the build on HIGH/CRITICAL findings.
5. Push only after scan gates pass.
6. Create a Binary Authorization attestation.
7. Admit deployment only when the required attestor signed the image.

## Primary Artifacts

- [Cloud Build secure supply chain pipeline](../cloud-build/secure-supply-chain.yaml)
- [Admission policy](../policies/admission-policy.yaml)
- [SLSA provenance predicate example](../provenance/slsa-provenance.example.json)
- [Attestation payload example](../attestations/binauthz-attestation-payload.example.json)

## Evidence Contract

Every successful build should retain:

- image digest,
- SBOM,
- vulnerability scan result,
- provenance or build predicate,
- attestation reference,
- deployment admission decision.

## Safety

Do not use floating image tags for production deployments. The baseline uses `$COMMIT_SHA` and expects policy to evaluate the immutable artifact reference.

