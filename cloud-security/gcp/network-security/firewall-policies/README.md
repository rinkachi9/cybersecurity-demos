# Cloud Firewall: Hierarchical Policies & Zero Trust Networking

Modern network security has moved beyond simple IP-based port blocking. A senior security architect focuses on **Hierarchical Guardrails** and **Identity-based rules** to create a scalable, secure network that follows the Principle of Least Privilege.

## 📊 Firewall Hierarchy (Mermaid Diagram)

```mermaid
graph TD
    subgraph Organization_Level [Organization / Folder Level]
        Hierarchical_Policy[Hierarchical Firewall Policy]
        Hierarchical_Rule[Global Deny: Public SSH/RDP]
    end

    subgraph VPC_Level [VPC Network Level]
        VPC_Firewall[VPC Firewall Rules]
        Service_Account_Rule[Allow: App-SA -> DB-SA (Port 5432)]
        Default_Deny[Fallback: Deny-All Ingress]
    end

    Organization_Level --> VPC_Level
    Hierarchical_Rule -- Overrides --> VPC_Firewall
    Service_Account_Rule -- Explicit Allow --> Default_Deny
```

## 🛡️ Senior Architect Strategy

### 1. Hierarchical Firewall Policies (HFP)
Traditionally, firewall rules are managed project-by-project, which is a nightmare for auditing. **HFPs** allow security teams to define "Global Guardrails" at the Organization or Folder level. 
- **Example**: A global rule that blocks all SSH (22) from the internet. No individual project owner can override this rule, ensuring compliance across the entire enterprise.

### 2. Service Account-based Rules (Identity-based)
Instead of using brittle IP addresses or Network Tags (which can be easily modified by developers), senior architects use **Service Accounts**. 
- **Scenario**: Only the `frontend` service account is allowed to connect to the `backend` service account. Even if the IP of the frontend VM changes, the rule remains valid and secure.

### 3. FQDN Filtering (Egress Control)
With **Cloud Firewall Plus**, we can create egress rules based on **Domain Names (FQDNs)** rather than IPs. This allows us to white-list traffic to `*.googleapis.com` or `*.github.com` without needing to track their constantly changing IP ranges.

### 4. Firewall Insights & Logging
Logging all denied traffic is critical for **Intrusion Detection**. In this demo, we enable logging on all major rules to provide visibility into potential attack attempts (e.g., automated port scanning).

## 🚀 Key Features in this Demo
1.  **Hierarchical Firewall Policy**: Global guardrail for an entire folder.
2.  **Identity-based Rules**: Communication between specific Service Accounts.
3.  **Default-Deny Ingress**: A fallback policy that blocks all un-matched traffic.
4.  **Logging & Auditing**: Detailed logs for blocked traffic.

---
*Reference: [GCP Cloud Firewall Overview](https://cloud.google.com/firewall/docs/firewall-policies)*
