# Evidence: Automated Incident Response

## Expected Evidence

- Redacted SCC finding payload.
- Pub/Sub message ID.
- Cloud Function execution log.
- Before and after bucket IAM or ACL state.
- Remediation decision: dry-run, applied, failed, or skipped.

## Do Not Commit

- Real bucket names that expose sensitive projects.
- Full IAM policies without redaction.

