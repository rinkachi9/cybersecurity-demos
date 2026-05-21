# Evidence: VPC Service Controls

## Expected Evidence

- Output from `python3 cloud-security/gcp/network-security/vpc-service-controls/tests/verify_terraform_contract.py`.
- Output from `terraform validate` or OpenTofu equivalent.
- Redacted Terraform plan showing `use_explicit_dry_run_spec = true`.
- Terraform outputs for access policy, service perimeter, protected resources, and restricted services.
- Denied access from outside the trusted context.
- Allowed access from inside the trusted context.
- Denied data copy to an untrusted external project.
- Approved egress exception test, if configured.
- Rollback or cleanup proof.

## Suggested Files

```text
01-terraform-contract.txt
02-terraform-validate.txt
03-dry-run-plan-redacted.txt
04-denied-untrusted-context-redacted.txt
05-allowed-trusted-context-redacted.txt
06-denied-exfiltration-redacted.txt
07-egress-exception-redacted.txt
08-rollback-or-cleanup-proof.txt
```

## Safety Notes

Run VPC SC demos in isolated test projects. A broad perimeter can block legitimate administration if applied carelessly.
