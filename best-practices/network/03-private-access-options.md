# 03. Private Access Options

Workloads often need to call Google APIs, managed services, SaaS-like producer services, and internal applications. Private access options reduce exposure to the public internet and make traffic paths more predictable and governable.

## What is private access?

**Private access** means that a workload can reach a service through private Google networking or internal IP addresses instead of through a public internet path. It does not automatically mean that the request is authorized. IAM, service identity, TLS, and logging are still required.

Important Google Cloud options:

- **Private Google Access (PGA)**: lets VMs without external IPs reach Google APIs and services.
- **Private Service Connect (PSC)**: exposes Google APIs, managed services, or producer services through private endpoints.
- **Private Service Access**: VPC peering based access used by some managed services.
- **VPC Network Peering**: connects VPC networks, but with transitive routing limitations.
- **Cloud NAT**: outbound internet access for private VMs; useful but not a private API access control.

## Architectural context

Private access is usually part of an egress strategy. The goal is to avoid giving workloads public IPs or broad internet egress just so they can call Google APIs. For sensitive workloads, private access should be paired with:

- restricted VIPs or PSC endpoints for Google APIs;
- firewall egress controls;
- service account based IAM;
- VPC Service Controls for protected APIs;
- DNS controls to prevent accidental public endpoint use;
- logging for egress traffic and API calls.

## Threats and failure modes this protects against

- **Public IP exposure** on workloads that only need Google API access.
- **Uncontrolled internet egress** used for data exfiltration or command and control.
- **Accidental public endpoint use** when a private path was intended.
- **Broad NAT access** that hides which workload made a connection.
- **Peering sprawl** that makes routing and access hard to reason about.
- **SaaS or producer service exposure** without consumer-side control.

## Choosing the right option

| Option | Use case | Notes |
| --- | --- | --- |
| Private Google Access | private VMs need Google APIs | enabled per subnet |
| Private Service Connect for Google APIs | private and granular Google API access | preferred for stronger control |
| Private Service Connect endpoint | consume a published service privately | good for producer-consumer patterns |
| Private Service Access | managed service private connectivity | used by Cloud SQL and similar services |
| VPC Peering | simple VPC-to-VPC connectivity | avoid large peering mesh designs |

## Implementation guidance for GCP

1. Remove external IPs from workloads that do not require inbound internet access.
2. Enable Private Google Access on subnets with private VMs.
3. Prefer Private Service Connect for controlled access to Google APIs and producer services.
4. Use private DNS zones so workloads resolve services to private endpoints.
5. Keep Cloud NAT narrow and monitor outbound destinations.
6. Avoid large VPC peering meshes; use Shared VPC or Network Connectivity Center where appropriate.
7. Combine private access with IAM and VPC Service Controls for sensitive APIs.

## Validation and evidence

Useful evidence includes:

- VM inventory showing no external IPs for private workloads;
- subnet configuration showing Private Google Access enabled;
- PSC endpoint configuration and DNS records;
- flow logs showing traffic to private endpoints;
- negative tests showing public endpoint access is blocked or not used;
- Cloud NAT logs for remaining internet egress.

## Common mistakes

- Assuming private access replaces IAM.
- Enabling Cloud NAT broadly and treating it as private access.
- Forgetting DNS, causing workloads to use public endpoints.
- Building peering meshes that become hard to audit.
- Allowing all Google APIs when only a small set is required.

## Checklist

- [ ] Private workloads do not have external IPs by default.
- [ ] Private Google Access or PSC is configured for required Google APIs.
- [ ] DNS resolves sensitive services to private endpoints.
- [ ] Internet egress through NAT is restricted and logged.
- [ ] VPC peering is limited and justified.
- [ ] Sensitive API access is paired with IAM and VPC SC.

---
Reference: [Private access options](https://cloud.google.com/vpc/docs/private-access-options)
