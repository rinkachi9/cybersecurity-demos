# Workload Identity Federation: Eliminating Static Keys

## 🔴 The Problem: Static Service Account Keys
Storing Service Account JSON keys as "Secrets" (e.g., GitHub Actions Secrets) poses significant risks.
- **Risk 1**: Keys have no expiration.
- **Risk 2**: Leaked keys can be used from anywhere.
- **Risk 3**: Key rotation is often neglected.

## 🟢 The Solution: Workload Identity Federation (WIF)
WIF allows external workloads to authenticate to GCP without a service account key using short-lived tokens.
- **Identity-based**: Authentication is tied to the identity of the GitHub repository/actor.
- **Keyless**: No JSON files to manage, store, or rotate.

## 🛠️ How to Implement
1. **GCP Side (Terraform)**: Create a pool and provider, and grant the `roles/iam.workloadIdentityUser` role to the specific GitHub repository principal.
2. **GitHub Side (Workflow)**: Add `permissions: id-token: write` and use the `google-github-actions/auth` action.

---
*Reference: [GCP Documentation - Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation)*
