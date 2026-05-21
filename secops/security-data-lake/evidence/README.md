# Evidence: Security Data Lake

## Expected Evidence

- Output from `python3 secops/security-data-lake/tests/verify_terraform_contract.py`.
- Output from `terraform validate` or OpenTofu equivalent.
- Redacted `terraform plan` showing BigQuery dataset, log sink, and dataset IAM.
- Terraform outputs for dataset ID, sink name, destination, and writer identity.
- Detection query output with redacted actors and resource identifiers.
- BigQuery job ID or scheduled query run ID.
- Data source tables used by the detection.
- False-positive notes and threshold tuning decisions.
- Cleanup proof for temporary scheduled queries, tables, or sandbox datasets.

## Suggested Files

```text
01-terraform-contract.txt
02-terraform-validate.txt
03-terraform-plan-redacted.txt
04-sink-writer-iam-redacted.txt
05-scheduled-query-run-redacted.txt
06-detection-output-redacted.json
07-cleanup-proof.txt
```

## Detection Evidence Structure

Each detection keeps source control artifacts under `detections/`:

```text
detection-name/
  README.md
  metadata.yaml
  query.sql
  sample-events.json
  expected-result.json
```

Runtime evidence should reference the detection ID and query version used for the test.
