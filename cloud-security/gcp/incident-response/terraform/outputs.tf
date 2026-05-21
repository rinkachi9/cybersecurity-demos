output "pubsub_topic_id" {
  description = "Pub/Sub topic ID for SCC findings."
  value       = google_pubsub_topic.scc_findings.id
}

output "scc_notification_config_name" {
  description = "SCC notification config resource name."
  value       = google_scc_notification_config.public_bucket_notify.name
}

output "remediator_function_name" {
  description = "Remediation Cloud Function name."
  value       = google_cloudfunctions_function.remediator.name
}
