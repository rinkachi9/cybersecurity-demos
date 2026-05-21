# Minimal Cloud IDS Example

This example creates a Cloud IDS endpoint, private service connection, reserved peering range, and packet mirroring policy for one monitored subnet.

```bash
terraform init
terraform plan \
  -var="project_id=demo-security-sandbox" \
  -var="network_name=security-monitoring-vpc" \
  -var="monitored_subnetwork_self_link=projects/demo-security-sandbox/regions/us-central1/subnetworks/monitored-subnet"
```

Use a short-lived sandbox because Cloud IDS can create meaningful cost. Collect setup and teardown evidence for every runtime test.
