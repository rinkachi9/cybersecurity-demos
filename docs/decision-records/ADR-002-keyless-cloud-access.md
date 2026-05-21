# ADR-002: Keyless Cloud Access

## Status

Accepted

## Context

Long-lived service account keys are a common cloud security risk. A portfolio that claims DevSecOps maturity should not normalize static JSON keys for CI/CD access to GCP.

## Decision

Prefer Workload Identity Federation for GitHub-to-GCP access. CI/CD templates should reference workload identity provider and service account variables rather than committed secrets or static key files.

## Consequences

- Pipelines depend on OIDC trust configuration.
- Setup is more complex than a JSON key, but the blast radius is lower.
- Evidence should show token exchange or successful keyless authentication without exposing project-sensitive identifiers.
