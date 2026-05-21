# 04. Disable Default Networks and Plan IP Space

Default configurations are optimized for quick starts, not enterprise security. Default VPC networks often include broad firewall rules and automatic subnet creation. In a mature environment, network design should start from explicit IP planning, routing, segmentation, and governance.

## What are default networks?

A **default VPC network** is automatically created in many new Google Cloud projects unless disabled by organization policy. It uses auto mode subnets and historically included permissive firewall rules for common protocols such as SSH, RDP, and ICMP from broad source ranges.

Even when default firewall rules are changed later, default networks encourage inconsistent project-by-project design. They also create overlapping IP ranges that become painful when projects need to connect.

## Architectural context

IP planning is a security and operations concern. Poor address planning leads to overlapping routes, emergency NAT, broad firewall exceptions, and migration delays. A secure cloud foundation should define:

- allowed VPC patterns;
- custom subnet mode;
- environment-specific IP ranges;
- reserved ranges for services and GKE;
- rules for hybrid connectivity;
- route advertisement standards;
- ownership of network changes.

## Threats and failure modes this protects against

- **Accidental public management access** through permissive default firewall rules.
- **Inconsistent network controls** across projects.
- **Route conflicts** during hybrid or multi-cloud connectivity.
- **Lateral movement** through flat default networks.
- **Emergency firewall exceptions** caused by poor IP planning.
- **Shadow infrastructure** created outside the approved network model.

## Implementation guidance for GCP

1. Enforce the organization policy that skips default network creation.
2. Delete unused default networks from existing projects after dependency review.
3. Use custom subnet mode for every production VPC.
4. Maintain an IP Address Management (IPAM) plan for projects, regions, and environments.
5. Reserve ranges for GKE pods, services, Private Service Access, and future expansion.
6. Use Terraform or a platform pipeline to create networks consistently.
7. Deny public SSH/RDP by default and require IAP or a controlled bastion pattern.

## IP planning considerations

| Area | Design question |
| --- | --- |
| Environment | Do prod, staging, and dev have non-overlapping ranges? |
| Region | Are regional subnets sized for growth? |
| GKE | Are pod and service ranges planned separately? |
| Hybrid | Will on-premises or other clouds overlap? |
| Managed services | Is Private Service Access reserved? |
| Future acquisitions | Is there space for new business units or networks? |

## Validation and evidence

Useful evidence includes:

- organization policy preventing default VPC creation;
- asset inventory showing no default networks in production projects;
- Terraform modules or blueprints for approved VPC creation;
- documented IPAM allocation table;
- firewall inventory showing no broad public SSH/RDP rules.

## Common mistakes

- Leaving default networks because "nothing is running there."
- Using auto mode VPCs in production.
- Reusing the same CIDR pattern in every project.
- Planning only VM ranges and forgetting GKE or managed services.
- Allowing project owners to create arbitrary VPCs.

## Checklist

- [ ] Default network creation is disabled by organization policy.
- [ ] Existing default networks are removed or formally excepted.
- [ ] Production VPCs use custom subnet mode.
- [ ] IP ranges are centrally planned and documented.
- [ ] Public SSH/RDP is blocked by default.
- [ ] Network creation is automated through approved IaC.

---
Reference: [Organization policy constraints](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints)
