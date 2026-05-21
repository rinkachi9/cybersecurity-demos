# Runbook: Security Data Lake Detection

## Purpose

Use this runbook to operate BigQuery-based security detections and collect evidence for suspicious activity.

## Preconditions

- Project, folder, or organization log sink is deployed.
- BigQuery dataset receives Cloud Audit, VPC Flow, WAF, and IDS logs.
- Analyst has read-only access to the security dataset.
- Scheduled detections are enabled only after query cost review.

## Trigger

- Scheduled detection query returns rows.
- Analyst starts threat hunting.
- SOAR playbook needs detection context.

## Triage

1. Identify the detection name and query version.
2. Confirm the data source table and time window.
3. Validate whether the actor, IP, project, or resource is expected.
4. Check related logs across identity, network, and data access.

## Response

1. Confirm the Terraform output for dataset, sink name, and writer identity.
2. Save the redacted query result.
3. Create or update an incident ticket.
4. Trigger the relevant SOAR playbook if the signal is high confidence.
5. Tune thresholds only after documenting false positives.

## Evidence

- Query name and version.
- Terraform validate or plan output with redactions.
- Sink writer identity and dataset IAM proof.
- Redacted result rows.
- Time window.
- Related logs.
- Analyst decision and next action.

## Cleanup

Remove temporary tables and expire ad hoc datasets used during testing. If the module was deployed only for review, disable scheduled detections before destroying the dataset.
