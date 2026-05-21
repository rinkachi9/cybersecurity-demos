# ADR-004: Evidence-First Modules

## Status

Accepted

## Context

Security controls are often described as if their presence is enough. In practice, controls need evidence: blocked requests, expected alerts, IAM checks, scan artifacts, runbook output, or cleanup proof.

## Decision

Promoted modules must define expected evidence and keep a module-local `evidence/README.md`. Runtime evidence should be redacted and tied to a command, expected result, actual result, and cleanup status.

## Consequences

- The repository can separate "designed", "locally validated", and "runtime proven" maturity.
- Reviewers can see which claims are static and which are operationally verified.
- Evidence collection becomes part of the module contract, not an afterthought.
