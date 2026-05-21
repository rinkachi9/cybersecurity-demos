# 03. Identity Federation and SSO

Identity federation allows Google Cloud access to be controlled by a central identity provider. This prevents the organization from maintaining separate accounts, passwords, MFA settings, and lifecycle processes in every environment.

## What are federation and SSO?

**Single Sign-On (SSO)** means that users authenticate through a central Identity Provider such as Google Workspace, Entra ID, Okta, or Ping Identity. Access to Google Cloud follows that central identity.

**Identity federation** is the trust relationship between the identity provider and Google Cloud. Common standards and patterns include:

- **SAML 2.0**: common in enterprise SSO.
- **OIDC**: a modern token-based standard using JWTs.
- **Workload Identity Federation (WIF)**: federation for workloads such as GitHub Actions, GitLab CI, AWS, or Azure without static JSON keys.

## Architectural context

Central identity enables consistent MFA, password policies, device posture checks, offboarding, and access review. This matters in cloud environments because console, API, CLI, and CI/CD access can all change real infrastructure.

Human federation and workload federation solve different problems:

- users authenticate with SSO and MFA;
- CI/CD pipelines use WIF and short-lived tokens;
- workloads in GKE or Cloud Run use Workload Identity or attached service accounts;
- external systems do not receive long-lived service account keys.

## Threats and failure modes this protects against

- **Old accounts** retaining access after an employee leaves.
- **Credential stuffing** against separate accounts without central MFA.
- **Phishing impact** when MFA and risk-based policies are missing.
- **Static JSON key leakage** in CI/CD systems.
- **Poor auditability** across many identity stores.
- **Shadow admin accounts** created outside the central IdP.

## Implementation guidance for GCP

1. Require SSO for console and CLI users.
2. Enforce MFA in the central IdP, especially for privileged users.
3. Map IdP groups to the groups used by Google Cloud IAM.
4. Use JIT provisioning when it fits the operating model.
5. Use Workload Identity Federation for GitHub Actions, GitLab CI, and external systems.
6. Restrict federated tokens by audience, subject, repository, branch, and environment.
7. Monitor sign-ins, failed authentication attempts, and token exchanges.

## Workload Identity Federation in practice

WIF allows a CI/CD pipeline to obtain a short-lived Google Cloud token based on an external identity. Instead of storing `service-account.json` in a CI secret store, the pipeline presents an OIDC token, and Google Cloud verifies conditions such as:

- the repository is `organization/app`;
- the branch is `main`;
- the workflow runs in an approved environment;
- the token issuer and audience match the configured provider.

This significantly reduces the impact of CI/CD secret exposure.

## Validation and evidence

Useful evidence includes:

- SSO and MFA configuration in the IdP;
- absence of static service account keys in CI/CD;
- Terraform or gcloud output for Workload Identity Pool and Provider;
- logs showing token exchange through WIF;
- a negative test where an unauthorized branch or repository cannot obtain a token.

## Common mistakes

- Moving users to SSO while leaving local accounts with permissions.
- WIF conditions that trust an entire GitHub organization instead of a specific repository.
- No MFA for administrators.
- Granting roles directly to federated users instead of groups.
- Not monitoring token exchange and failed authentication.

## Checklist

- [ ] Users authenticate through central SSO.
- [ ] MFA is mandatory for Google Cloud access.
- [ ] IdP groups map cleanly to the IAM model.
- [ ] CI/CD pipelines use WIF instead of JSON keys.
- [ ] WIF conditions restrict repository, branch, audience, and subject.
- [ ] Sign-ins and token exchanges are monitored.

---
Reference: [Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)
