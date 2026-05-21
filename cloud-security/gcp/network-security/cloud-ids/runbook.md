# Runbook: Cloud IDS

## Purpose

Use this runbook to deploy, verify, and tear down a short-lived Cloud IDS test in a sandbox VPC.

## Preconditions

- Dedicated sandbox project is available.
- Cloud IDS API, Compute API, and Service Networking API are enabled or explicitly enabled by Terraform.
- Monitored subnet, instance, or network tag scope is intentionally narrow.
- Cost owner approves the test window.
- Security Command Center or Cloud Logging access is available for finding review.

## Trigger

- Cloud IDS deployment review.
- Network intrusion detection validation.
- SCC finding investigation.
- Packet mirroring scope change.

## Triage

1. Confirm the IDS endpoint location and VPC.
2. Confirm packet mirroring collector uses the IDS endpoint forwarding rule.
3. Confirm mirrored resources are limited to the intended subnet, instances, or tags.
4. Confirm mirrored CIDR ranges and protocols match the test.
5. Confirm SCC or Cloud Logging received the expected finding.

## Response

1. Run the local Terraform contract check.
2. Review the Terraform plan and cost scope.
3. Apply only in a short-lived sandbox.
4. Run the approved threat simulation command.
5. Capture the SCC or Cloud Logging finding.
6. Tear down the endpoint and packet mirroring policy after evidence capture.

## Evidence

- Terraform validate or plan output with redactions.
- IDS endpoint name, location, severity, and forwarding rule.
- Packet mirroring policy and mirrored resource scope.
- Threat simulation command.
- SCC or Cloud Logging finding.
- Teardown proof.

## Rollback

Disable packet mirroring first if the mirrored scope is wrong. Destroy the IDS endpoint after evidence capture. Keep the Service Networking reserved range only if it is shared with other approved services.
