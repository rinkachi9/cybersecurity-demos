resource "google_pubsub_topic" "scc_findings" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

resource "google_service_account" "workflow_sa" {
  project      = var.project_id
  account_id   = var.workflow_service_account_id
  display_name = "SOAR Orchestrator Service Account"
}

resource "google_service_account" "trigger_sa" {
  project      = var.project_id
  account_id   = var.trigger_service_account_id
  display_name = "SOAR Eventarc Trigger Service Account"
}

resource "google_cloudfunctions_function" "enrichment" {
  project     = var.project_id
  region      = var.region
  name        = var.enrichment_function_name
  description = "Enriches SCC findings with deterministic threat context."
  runtime     = "python310"

  available_memory_mb   = 256
  source_archive_bucket = var.function_source_bucket
  source_archive_object = var.enrichment_source_object
  entry_point           = "enrich_finding"
  trigger_http          = true
}

resource "google_cloudfunctions_function" "remediation" {
  project     = var.project_id
  region      = var.region
  name        = var.remediation_function_name
  description = "Dry-run capable remediation worker."
  runtime     = "python310"

  available_memory_mb   = 256
  source_archive_bucket = var.function_source_bucket
  source_archive_object = var.remediation_source_object
  entry_point           = "remediate_finding"
  trigger_http          = true
}

resource "google_workflows_workflow" "soar_playbook" {
  project         = var.project_id
  name            = var.workflow_name
  region          = var.region
  description     = "Orchestrates response to leaked service account keys."
  service_account = google_service_account.workflow_sa.email
  source_contents = file("${path.module}/../workflows/leaked_key_playbook.yaml")

  user_env_vars = {
    ENRICHMENT_FUNCTION_URL = google_cloudfunctions_function.enrichment.https_trigger_url
    REMEDIATION_FUNCTION_URL = google_cloudfunctions_function.remediation.https_trigger_url
    GOOGLE_CLOUD_PROJECT_ID  = var.project_id
    SOAR_DRY_RUN             = tostring(var.dry_run)
  }
}

resource "google_eventarc_trigger" "scc_trigger" {
  project  = var.project_id
  name     = var.eventarc_trigger_name
  location = var.region

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
