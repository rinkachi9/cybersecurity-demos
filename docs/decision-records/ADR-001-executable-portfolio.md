# ADR-001: Executable Portfolio

## Status

Accepted

## Context

Security portfolios often become collections of screenshots, diagrams, and tool lists. That is not enough to prove senior-level engineering judgment. A reviewer should be able to inspect structure, run local checks, and see how security controls map to evidence.

## Decision

Treat this repository as an executable expert portfolio. Promoted modules should include metadata, runbooks where relevant, evidence expectations, validation scripts, and clear readiness status.

## Consequences

- Every promoted module needs a repeatable review path.
- Static documentation is useful only when connected to validation or expected evidence.
- Runtime claims require redacted proof.
- The central validator becomes a lightweight quality gate for repository maturity.
