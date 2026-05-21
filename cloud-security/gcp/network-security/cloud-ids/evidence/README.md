# Evidence: Cloud IDS

## Expected Evidence

- Output from `python3 cloud-security/gcp/network-security/cloud-ids/tests/verify_terraform_contract.py`.
- Output from `terraform validate` or OpenTofu equivalent.
- Redacted Terraform plan showing IDS endpoint, Service Networking, and packet mirroring.
- IDS endpoint configuration.
- IDS endpoint forwarding rule used by packet mirroring.
- Packet mirroring policy attached to the test subnet.
- Simulated threat request or traffic generator command.
- SCC or Cloud Logging finding for the simulated event.
- Teardown proof from the short-lived test environment.

## Suggested Files

```text
01-terraform-contract.txt
02-terraform-validate.txt
03-terraform-plan-redacted.txt
04-ids-endpoint-redacted.txt
05-packet-mirroring-policy-redacted.txt
06-threat-simulation-command.txt
07-scc-finding-redacted.json
08-teardown-proof.txt
```

## Cost Notes

Cloud IDS can be expensive. Capture setup and teardown evidence for every test run. Keep mirroring scope narrow and avoid long-running endpoints in shared projects.

