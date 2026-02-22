# Advanced SOAR Architecture: Event-Driven Security Orchestration

In mature security operations, we move beyond simple scripts to **orchestrated workflows**. This module demonstrates a complete SOAR (Security Orchestration, Automation, and Response) system built natively on Google Cloud.

## 📊 Workflow Logic (Mermaid Diagram)

```mermaid
graph TD
    SCC[Security Command Center] -- Finding: Leaked Key --> PubSub[Pub/Sub Topic]
    PubSub -- Trigger --> Eventarc[Eventarc Trigger]
    Eventarc -- Execute --> Workflow[Cloud Workflow (The Brain)]

    subgraph Orchestration_Layer [The Playbook]
        Workflow -- Step 1: Call --> Enrich[Function: Enrichment]
        Enrich -- Risk Score --> Decision{Risk > 80?}
        
        Decision -- Yes (High Risk) --> Remediate[Function: Disable Key]
        Decision -- No (Medium Risk) --> Ticket[Jira Ticket]
        
        Remediate -- Success --> Notify[Slack Alert]
    end
```

## 🛡️ Why Cloud Workflows for SOAR?

### 1. State Management & Logic
Unlike a single monolithic Cloud Function, **Cloud Workflows** allows you to define complex logic trees (switch/case, loops, error handling) in a declarative YAML format. This makes the "Playbook" readable and auditable by non-programmers.

### 2. Decoupling (Microservices approach)
- **The Brain (Workflow)**: Decides *what* to do.
- **The Hands (Functions)**: Know *how* to do it (e.g., call VirusTotal API, disable IAM key).
This allows you to reuse the "Disable Key" function in multiple different playbooks.

### 3. Serverless & Event-Driven
The entire architecture scales to zero. You pay nothing when there are no alerts.

## 🚀 Key Components
1.  **Ingestion**: SCC Findings (Leaked Service Account Key).
2.  **Orchestration**: A `main.yaml` playbook that enriches data and makes decisions based on risk score.
3.  **Enrichment Worker**: A Python function that simulates checking Threat Intel (e.g., VirusTotal).
4.  **Remediation Worker**: A Python function that uses the IAM API to disable the compromised key.

## 🛠️ How to Deploy?
1. Deploy the infrastructure with Terraform (`terraform apply`).
2. Simulate a finding by publishing a message to the Pub/Sub topic:
```bash
gcloud pubsub topics publish scc-leaked-keys --message='{"finding": {"resourceName": "projects/-/serviceAccounts/ compromised@test.iam.gserviceaccount.com", "severity": "CRITICAL"}}'
```
3. Observe the execution in the **Cloud Workflows** console.

---
*Reference: [GCP Workflows for Security Automation](https://cloud.google.com/workflows/docs/tutorials/security-automation)*
