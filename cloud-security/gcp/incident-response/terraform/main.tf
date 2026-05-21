resource "google_pubsub_topic" "scc_findings" {
  project = var.project_id
  name    = var.pubsub_topic_name
}

resource "google_scc_notification_config" "public_bucket_notify" {
  config_id    = var.scc_notification_config_id
  organization = var.organization_id
  pubsub_topic = google_pubsub_topic.scc_findings.id
  description  = "Sends public bucket findings to Pub/Sub for controlled remediation."

  streaming_config {
    filter = var.scc_finding_filter
  }
}

resource "google_cloudfunctions_function" "remediator" {
  project     = var.project_id
  region      = var.region
  name        = var.function_name
  description = "Dry-run capable remediation function for public bucket findings."
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = var.source_archive_bucket
  source_archive_object = var.source_archive_object
  entry_point           = var.function_entry_point

  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.scc_findings.id
  }

  environment_variables = {
    GCP_PROJECT_ID = var.project_id
    DRY_RUN        = tostring(var.dry_run)
  }
}

resource "google_project_iam_member" "remediator_storage_admin" {
  count = var.grant_remediator_storage_admin ? 1 : 0

  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_cloudfunctions_function.remediator.service_account_email}"
}
