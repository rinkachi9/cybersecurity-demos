# IAM Security Best Practices: Table of Contents

This directory describes identity and access management practices for Google Cloud. The guides are written for security review: they explain core concepts, architectural context, common attacks, implementation patterns, validation evidence, and operational mistakes to avoid.

## Practice list

1. **[Principle of Least Privilege](./01-principle-of-least-privilege.md)**: PoLP, Google Cloud roles, privilege escalation, high-risk roles, and permission reduction.
2. **[Group-Based Access Management](./02-group-based-management.md)**: RBAC, groups, offboarding, membership review, and removal of direct user grants.
3. **[Identity Federation and SSO](./03-identity-federation-sso.md)**: SAML, OIDC, MFA, Workload Identity Federation, and keyless CI/CD.
4. **[Service Account Management](./04-service-account-management.md)**: workload identities, impersonation, avoiding JSON keys, and usage monitoring.
5. **[IAM Conditions and Context-Aware Access](./05-conditional-access-context-aware.md)**: time-bound access, device posture, Access Context Manager, IAP, and Zero Trust.
6. **[Regular Access Reviews and IAM Auditing](./06-regular-access-reviews-auditing.md)**: access review, IAM Recommender, IAM change detections, and compliance evidence.

## How to use this section

Start with the model: groups, roles, service accounts, and federation. Then constrain access with conditions, monitor changes, and remove unused permissions regularly. IAM is a continuous process, not a one-time configuration.

---
Senior Security Architecture Portfolio
