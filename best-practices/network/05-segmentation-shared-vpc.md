# 05. Network Segmentation and Shared VPC

Network segmentation limits how far an attacker, misconfiguration, or faulty workload can spread. Shared VPC provides a controlled way to centralize network ownership while allowing application teams to deploy workloads in separate service projects.

## What is segmentation?

**Network segmentation** divides systems into separate network zones based on environment, sensitivity, function, or ownership. The goal is to ensure that compromise of one workload does not automatically grant access to unrelated systems.

Common segmentation dimensions:

- production, staging, and development;
- public-facing, internal, and data tiers;
- regulated and non-regulated workloads;
- shared services and application teams;
- administrative and runtime networks.

## What is Shared VPC?

**Shared VPC** lets an organization host VPC networks in a central host project and attach service projects to those networks. Network administrators manage subnets, routes, and firewall policies in the host project. Application teams deploy resources in service projects without owning the core network.

This model separates duties:

- platform or network team controls network architecture;
- application teams control their workloads;
- security team reviews guardrails and exceptions.

## Threats and failure modes this protects against

- **Lateral movement** between unrelated workloads.
- **Project-level network sprawl** where every team creates its own VPC.
- **Inconsistent firewall policy** across projects.
- **Over-privileged developers** with network admin rights in production.
- **Route and peering complexity** from many independent networks.
- **Blast radius expansion** when dev and prod share weak boundaries.

## Implementation guidance for GCP

1. Use Shared VPC for production and other centrally governed environments.
2. Separate host projects from service projects.
3. Grant network administration only to the platform or network team.
4. Use service projects to isolate application ownership and IAM.
5. Segment subnets by environment, trust zone, and workload tier.
6. Apply hierarchical firewall policies for global guardrails.
7. Use VPC Service Controls for sensitive data projects where API perimeter protection is required.
8. Document exceptions for cross-zone traffic.

## Segmentation patterns

| Pattern | Use case | Notes |
| --- | --- | --- |
| Environment segmentation | prod, staging, dev separation | prevents accidental cross-environment access |
| Tier segmentation | web, app, data tiers | limits application compromise paths |
| Regulated data zone | PCI, PII, or restricted data | requires stronger logging and access controls |
| Shared services zone | DNS, CI/CD, observability | needs strict inbound and outbound rules |
| Admin zone | bastion, IAP, tooling | should be highly monitored |

## Validation and evidence

Useful evidence includes:

- Shared VPC host and service project mapping;
- IAM policy showing limited network administrator access;
- firewall rules or policies enforcing tier boundaries;
- VPC Flow Logs showing expected allowed and denied flows;
- architecture diagrams that identify trust zones;
- negative tests showing blocked cross-zone access.

## Common mistakes

- Using one large flat VPC for all environments.
- Giving application teams network admin rights in the host project.
- Relying only on subnet names without firewall enforcement.
- Excessive VPC peering instead of Shared VPC.
- No documented owner for cross-zone allow rules.

## Checklist

- [ ] Production uses a centrally governed Shared VPC or equivalent model.
- [ ] Host and service project responsibilities are separated.
- [ ] Workloads are segmented by environment and sensitivity.
- [ ] Cross-zone traffic is explicitly allowed and documented.
- [ ] Network admin permissions are tightly controlled.
- [ ] Flow logs and firewall logs support segmentation review.

---
Reference: [Shared VPC overview](https://cloud.google.com/vpc/docs/shared-vpc)
