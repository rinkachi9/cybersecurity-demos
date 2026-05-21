# 05. IAM Conditions and Context-Aware Access

Authentication tells you who the user or workload is. It does not tell you whether access should be allowed at this moment, from this device, from this location, and for this operation. Conditional access adds context to authorization.

## What are IAM Conditions?

**IAM Conditions** add a condition to a role binding. A user can have a role only until a specific date, only for resources with a specific name pattern, or only when a CEL expression evaluates to true.

Common uses include:

- temporary incident access;
- restricting a role to resources with a specific prefix;
- allowing access only for a specific resource type;
- break-glass access with an expiration date.

## What is Context-Aware Access?

**Context-Aware Access (CAA)** controls access based on request context such as device posture, source IP, region, group membership, and endpoint security state. In Google Cloud, it uses Access Context Manager and is often combined with IAP and VPC Service Controls.

CAA answers the question: "Is this valid identity operating from a trusted context?"

## Architectural context

Conditional access is a core part of Zero Trust. A user is not trusted only because they are "inside the company" or know the password. Access should depend on:

- identity;
- group and role;
- device posture;
- location;
- time;
- data sensitivity;
- operation risk.

IAM Conditions constrain IAM role bindings. Context-Aware Access constrains application and API access based on context. The two mechanisms should complement each other.

## Threats and failure modes this protects against

- **Use of stolen credentials** from an untrusted location or device.
- **Permanent temporary access** left behind after an incident.
- **Access from unmanaged endpoints** without disk encryption, updates, or endpoint protection.
- **After-hours data exfiltration** by an account with a valid role.
- **Misuse of a role** against resources outside the intended scope.
- **Data perimeter bypass** when network or device context is not checked.

## Implementation guidance for GCP

1. Start with IAM Conditions for temporary access and break-glass workflows.
2. Add conditions to high-risk roles instead of granting them indefinitely.
3. Use Access Levels for IP ranges, devices, regions, and groups.
4. Protect administrative applications with IAP and CAA.
5. Combine CAA with VPC Service Controls for high-risk data.
6. Test conditions positively and negatively before production rollout.
7. Log and monitor denied requests.

## Example controls

| Control | Example | Purpose |
| --- | --- | --- |
| Time-bound access | role expires after 8 hours | incident response access |
| Resource prefix | access only to buckets named `team-a-*` | blast radius reduction |
| Device posture | access only from managed devices | stolen credential protection |
| Source IP | access only from corporate VPN | context restriction |

## Validation and evidence

Useful evidence includes:

- IAM policy with a condition and expiration date;
- Access Level configuration in Access Context Manager;
- a negative test from an untrusted IP or device;
- denied access logs from IAP or VPC SC;
- a report of high-risk roles without conditions.

## Common mistakes

- Conditions so complex that operators cannot reason about them.
- No negative tests before rollout.
- Time conditions without renewal or approval workflow.
- Treating corporate IP as the only trust signal.
- No emergency break-glass path.

## Checklist

- [ ] Privileged access has time-based or context-based conditions.
- [ ] CAA protects administrative and sensitive applications.
- [ ] Access Levels are versioned and tested.
- [ ] Denied requests are logged and monitored.
- [ ] A break-glass procedure exists.
- [ ] Conditions are documented clearly enough for audit review.

---
Reference: [IAM Conditions overview](https://cloud.google.com/iam/docs/conditions-overview)
