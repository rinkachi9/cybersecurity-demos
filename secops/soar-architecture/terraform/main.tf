# Advanced SOAR Architecture: Terraform Deployment
# This sets up the Pub/Sub topic, Cloud Functions, and the Orchestration Workflow.

# 1. Pub/Sub Topic: Receive Findings from SCC
resource "google_pubsub_topic" "scc_findings" {
  name = "scc-leaked-keys"
}

# 2. Cloud Function: Enrichment (Mock VirusTotal / IP Check)
resource "google_cloudfunctions_function" "enrichment" {
  name        = "soar-enrichment-worker"
  description = "Enriches findings with threat intelligence"
  runtime     = "python310"

  available_memory_mb   = 256
  source_archive_bucket = "your-function-bucket"
  source_archive_object = "enrichment.zip"
  entry_point           = "enrich_finding"
  trigger_http          = true
}

# 3. Cloud Function: Remediation (Disable Key)
resource "google_cloudfunctions_function" "remediation" {
  name        = "soar-remediation-worker"
  description = "Executes remediation actions (Disable IAM Keys)"
  runtime     = "python310"

  available_memory_mb   = 256
  source_archive_bucket = "your-function-bucket"
  source_archive_object = "remediation.zip"
  entry_point           = "remediate_finding"
  trigger_http          = true
}

# 4. Cloud Workflows (The Orchestrator)
# This defines the "Brain" of our SOAR system.
resource "google_workflows_workflow" "soar_playbook" {
  name            = "leaked-key-response-playbook"
  region          = "us-central1"
  description     = "Orchestrates response to leaked service account keys"
  service_account = google_service_account.workflow_sa.email
  
  # The YAML source code we defined earlier
  source_contents = file("${path.module}/../workflows/leaked_key_playbook.yaml")
  
  # Inject dynamic URLs of our worker functions into the workflow environment
  user_env_vars = {
    ENRICHMENT_FUNCTION_URL = google_cloudfunctions_function.enrichment.https_trigger_url
    REMEDIATION_FUNCTION_URL = google_cloudfunctions_function.remediation.https_trigger_url
    GOOGLE_CLOUD_PROJECT_ID  = var.project_id
  }
}

# 5. Eventarc Trigger (The Connector)
# Automatically triggers the Workflow when a message arrives in Pub/Sub.
resource "google_eventarc_trigger" "scc_trigger" {
  name     = "trigger-soar-on-finding"
  location = "us-central1"
  
  matching_criteria {
    attribute = "type"
    value     = "google.cloud.pubsub.topic.v1.messagePublished"
  }
  
  destination {
    workflow = google_workflows_workflow.soar_playbook.id
  }

  service_account = google_service_account.trigger_sa.email
  transport {
    pubsub {
      topic = google_pubsub_topic.scc_findings.id
    }
  }
}

# Service Accounts (Least Privilege)
resource "google_service_account" "workflow_sa" {
  account_id   = "soar-workflow-sa"
  display_name = "SOAR Orchestrator Service Account"
}

resource "google_service_account" "trigger_sa" {
  account_id   = "soar-trigger-sa"
  display_name = "Eventarc Trigger Service Account"
}
