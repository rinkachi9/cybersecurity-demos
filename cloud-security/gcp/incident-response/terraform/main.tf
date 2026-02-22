# Automated Incident Response: Self-Healing Security
# This setup listens for SCC findings and triggers a Cloud Function for remediation.

# 1. Pub/Sub Topic for Security Findings
resource "google_pubsub_topic" "scc_findings" {
  name = "scc-remediation-topic"
}

# 2. SCC Notification Config
# Filter: Any "Public Bucket" finding in the organization/project
resource "google_scc_notification_config" "public_bucket_notify" {
  config_id    = "public-bucket-remediation"
  organization = "YOUR_ORG_ID"
  pubsub_topic = google_pubsub_topic.scc_findings.id
  description  = "Sends Public Bucket findings to Pub/Sub for automatic remediation"

  streaming_config {
    filter = "category = "PUBLIC_BUCKET_ACL" AND state = "ACTIVE""
  }
}

# 3. Cloud Function (Remediation logic)
resource "google_cloudfunctions_function" "remediator" {
  name        = "auto-remediate-public-bucket"
  description = "Automatically removes public access from GCS buckets"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = "YOUR_SOURCE_BUCKET"
  source_archive_object = "remediator.zip"
  entry_point           = "remediate_bucket"
  
  event_trigger {
    event_type = "google.pubsub.topic.publish"
    resource   = google_pubsub_topic.scc_findings.id
  }

  environment_variables = {
    GCP_PROJECT_ID = "YOUR_PROJECT_ID"
  }
}

# 4. IAM Roles for the Function (Least Privilege)
# The function needs to be able to modify bucket ACLs/IAM
resource "google_project_iam_member" "remediator_storage_admin" {
  project = "YOUR_PROJECT_ID"
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_cloudfunctions_function.remediator.service_account_email}"
}
