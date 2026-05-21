# Runbook Template

## Purpose

Describe when this runbook should be used and what risk it mitigates.

## Preconditions

- Required project, account, or lab environment.
- Required tools and permissions.
- Expected safety mode, for example `dry_run`.

## Trigger

Describe the event, alert, finding, or manual signal that starts the procedure.

## Triage

1. Confirm the affected resource.
2. Confirm severity and blast radius.
3. Check whether the finding is active, stale, or a false positive.

## Response

1. Run the safest validation command.
2. Collect evidence.
3. Apply containment or remediation.
4. Notify the relevant owner.

## Evidence

- Alert or finding identifier.
- Relevant logs.
- Command output after redaction.
- Before and after state.

## Rollback

Describe the rollback or exception path when remediation has an unintended effect.

## Cleanup

Describe temporary resources, files, or access grants that must be removed.

