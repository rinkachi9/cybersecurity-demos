# 06. Firewall Hierarchy and Identity-Based Rules

Firewall rules are one of the most visible network security controls, but they are often misused as broad IP allow lists. A mature Google Cloud firewall strategy uses layered policies, identity-aware targeting, default deny behavior, logging, and regular cleanup.

## What are Google Cloud firewall policies?

Google Cloud supports several firewall control layers:

- **Hierarchical firewall policies**: organization or folder level guardrails.
- **Global and regional network firewall policies**: reusable policy objects for VPCs.
- **VPC firewall rules**: network-level rules applied to VMs.
- **Firewall rules logging**: logs for allow and deny decisions.
- **Firewall Insights**: analysis of overly permissive, shadowed, or unused rules.

Unlike traditional perimeter firewalls, cloud firewalls should often target workload identity, not only IP ranges. In GCP, VM firewall rules can target service accounts and network tags.

## Architectural context

The firewall model should separate global guardrails from application-specific rules. For example:

- organization policy blocks inbound SSH/RDP from the internet;
- folder policy enforces production-specific restrictions;
- network policy defines shared environment rules;
- application rules allow only required traffic between tiers.

This reduces the risk that a project owner can override critical security controls.

## Threats and failure modes this protects against

- **Public management exposure** such as SSH or RDP from `0.0.0.0/0`.
- **Lateral movement** between workloads that should not communicate.
- **Overly broad allow rules** created during troubleshooting.
- **Shadowed deny rules** that appear protective but are overridden.
- **Unlogged access paths** that make incident response difficult.
- **Tag abuse** where a workload can add a tag to receive more access.

## Implementation guidance for GCP

1. Define organization-level deny rules for prohibited inbound traffic.
2. Use default deny for ingress and allow only required flows.
3. Prefer service account based rules over broad source ranges or mutable tags.
4. Use hierarchical firewall policies for non-negotiable guardrails.
5. Log critical allow and deny rules.
6. Use Firewall Insights to identify broad, unused, or shadowed rules.
7. Require ownership, justification, and expiration for temporary rules.
8. Manage firewall policies through IaC and code review.

## Rule design model

| Rule type | Purpose | Example |
| --- | --- | --- |
| Global deny | non-negotiable guardrail | block public SSH/RDP |
| Environment allow | shared access pattern | monitoring agents to collectors |
| Application allow | required app flow | web tier to app tier on 443 |
| Data tier allow | tightly scoped database access | app service account to database port |
| Temporary exception | incident or migration access | expires automatically |

## Validation and evidence

Useful evidence includes:

- hierarchical policy showing global deny rules;
- firewall inventory with owners and business justification;
- logs for critical allow and deny rules;
- Firewall Insights report for unused or overly permissive rules;
- negative test showing blocked access from an unauthorized source;
- IaC review history for firewall changes.

## Common mistakes

- Using `0.0.0.0/0` for management access.
- Relying on network tags that application teams can modify.
- Not logging deny rules that are important for detection.
- Keeping temporary troubleshooting rules forever.
- Creating project-level rules that conflict with enterprise guardrails.

## Checklist

- [ ] Hierarchical firewall policies enforce global guardrails.
- [ ] Ingress follows default deny.
- [ ] Service account based targeting is used where possible.
- [ ] Critical firewall rules have logging enabled.
- [ ] Temporary rules have owners and expiration.
- [ ] Firewall Insights is reviewed regularly.

---
Reference: [Firewall policies overview](https://cloud.google.com/firewall/docs/firewall-policies)
