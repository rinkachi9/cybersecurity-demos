# Governance as Code: Organization Policies (Guardrails)

At a senior level, we focus on building systems that **prevent** configuration errors across the entire organization (hundreds of projects).

## 🛡️ What are Guardrails?
Organization Policies are top-down constraints that act independently of IAM permissions. Even a `Project Owner` cannot create a public IP if the policy forbids it.

## 🚀 Examples in this Demo
1. **Disable Service Account Key Creation**: Forces the use of **Workload Identity Federation** or **IAP**.
2. **Skip Default Network**: Prevents new projects from starting with the insecure 'default' VPC.
3. **Uniform Bucket-Level Access (GCS)**: Standardizes access control for Cloud Storage using only IAM.
4. **Resource Locations**: Restricts resource creation to specific regions (e.g., EU) for GDPR compliance.

---
*Reference: [GCP Organization Policy Constraints](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints)*
