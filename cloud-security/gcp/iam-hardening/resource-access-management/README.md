# Advanced IAM & Resource Access Management (PoLP)

Identity and Access Management (IAM) is the first and last line of defense in the cloud. A senior-level IAM strategy focuses on **identity-based security** that follows the **Principle of Least Privilege (PoLP)**—giving only the minimum access needed for a specific task.

## 📊 Identity Hierarchy (Mermaid Diagram)

```mermaid
graph TD
    subgraph Identity_Sources [Identity Management]
        G_Suite[Google Workspace / Cloud Identity]
        Groups[Security Groups: Ad-hoc, RBAC]
    end

    subgraph Access_Control [Resource Access Control]
        Group_Auditor[Group: security-auditors] -- Custom Role: Auditor --> Org_Policy[Full Organization]
        User_Dev[User: dev-on-call] -- Conditional Role: Admin --> Project_X[Project X (Temporary)]
        Group_Data[Group: data-analysts] -- Predefined Role: Viewer --> Bucket_Y[Specific Bucket Y]
    end

    G_Suite --> Groups
    Groups --> Group_Auditor
    Groups --> User_Dev
    Groups --> Group_Data
```

## 🛡️ Senior Architect Best Practices

### 1. Custom Roles over Predefined Roles
GCP has many predefined roles (e.g., `roles/editor`), but they are often too broad and "noisy." A senior architect creates **Custom Roles** that contain only the specific API permissions (`compute.instances.list`, etc.) required for a specific business function.

### 2. Group-Based Management (Not Individual Users)
Managing access for individual users is not scalable and leads to "permission sprawl." Access should always be granted to **Groups** (e.g., `group:dev-team@yourdomain.com`). When a user joins or leaves the team, you update the group membership, not the IAM policies.

### 3. Resource-Level vs. Project-Level Access
Instead of granting a user access to *all* buckets in a project, grant them access only to the *specific* bucket they need. This limits the "blast radius" if a user's account is compromised.

### 4. Conditional IAM (Context-Aware)
Using **IAM Conditions** allows you to grant access that automatically expires or is only valid during specific times or from specific IP ranges, providing a "Just-In-Time" (JIT) access experience.

## 🚀 Key Features in this Demo
1.  **Custom Role Creation**: Granular permissions for a Security Auditor.
2.  **Group-Based Bindings**: Centralized management of access.
3.  **Resource-Level Scoping**: Access restricted to a single GCS bucket.
4.  **Conditional Access**: Time-based expiring permissions.

---
*Reference: [GCP IAM Best Practices](https://cloud.google.com/iam/docs/using-iam-custom-roles)*
