# Security Data Lake: Centralized Log Aggregation
# This setup exports all security-critical logs to BigQuery for detection engineering.

# 1. BigQuery Dataset for Security Logs
resource "google_bigquery_dataset" "security_logs" {
  dataset_id                  = "security_data_lake"
  friendly_name               = "Security Data Lake"
  description                 = "Centralized storage for all GCP security logs"
  location                    = "US"
  delete_contents_on_destroy = true
}

# 2. Organization Log Sink (Aggregation)
# Collects logs from ALL projects in the organization/folder.
resource "google_logging_organization_sink" "security_sink" {
  name             = "centralized-security-logs-sink"
  description      = "Exports all security-relevant logs to BigQuery"
  org_id           = "YOUR_ORG_ID"
  destination      = "bigquery.googleapis.com/${google_bigquery_dataset.security_logs.id}"
  
  # Filter for high-value security logs
  filter = <<EOF
    resource.type="gce_instance" OR 
    resource.type="gcs_bucket" OR 
    logName:"cloudaudit.googleapis.com%2Factivity" OR
    logName:"cloudaudit.googleapis.com%2Fdata_access" OR
    jsonPayload.enforcedSecurityPolicy.name:"enterprise-waf-policy" OR
    logName:"compute.googleapis.com%2Fvpc_flows"
  EOF

  include_children = true
}

# 3. Permissions for the Log Sink to write to BigQuery
resource "google_project_iam_member" "log_sink_bigquery_editor" {
  project = "YOUR_PROJECT_ID"
  role    = "roles/bigquery.dataEditor"
  member  = google_logging_organization_sink.security_sink.writer_identity
}
