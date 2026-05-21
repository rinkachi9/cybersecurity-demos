# ADR-003: Dry-Run Remediation

## Status

Accepted

## Context

Automated remediation can reduce response time, but it can also create outages when the signal is wrong or the workflow lacks approval boundaries.

## Decision

Default SOAR remediation to `dry_run`. Automated actions should first produce a deterministic decision, recommended action, and expected effect. Real remediation should require an explicit configuration change or approval path.

## Consequences

- Local tests can validate response logic safely.
- Evidence can be collected without changing cloud resources.
- Production use still needs approval design, audit logging, rollback, and service ownership mapping.
