# 03. Identity Federation and SSO

Centralize identity management to ensure consistent authentication and authorization across all environments.

## 🛡️ Architect's Perspective
Leverage **SAML 2.0 or OIDC** to federate your existing identity provider (e.g., Azure AD, Okta) with Google Cloud. This allows for **Single Sign-On (SSO)**, which simplifies the user experience and ensures that when a user is disabled in the central IDP, they lose access to GCP immediately.

### ✅ Checklist for Identity Federation
- [ ] Enable **SSO** for all users accessing the Google Cloud Console and SDK.
- [ ] Use **Workload Identity Federation (WIF)** for secure, keyless authentication from external clouds (AWS, Azure) or CI/CD pipelines (GitHub, GitLab).
- [ ] Enforce **Multi-Factor Authentication (MFA)** at the identity provider level.
- [ ] Implement **Just-In-Time (JIT)** provisioning for temporary access.

---
*Reference: [GCP Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)*
