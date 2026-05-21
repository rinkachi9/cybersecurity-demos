output "dataset_id" {
  description = "BigQuery security data lake dataset ID."
  value       = google_bigquery_dataset.security_logs.dataset_id
}

output "dataset_self_link" {
  description = "BigQuery dataset self link."
  value       = google_bigquery_dataset.security_logs.self_link
}

output "dataset_location" {
  description = "BigQuery dataset location."
  value       = google_bigquery_dataset.security_logs.location
}

output "log_sink_name" {
  description = "Cloud Logging sink name."
  value       = local.log_sink_name
}

output "log_sink_writer_identity" {
  description = "Generated Cloud Logging writer identity that receives dataset write access."
  value       = local.log_sink_writer_identity
}

output "log_sink_destination" {
  description = "BigQuery destination used by the Cloud Logging sink."
  value       = local.sink_destination
}

output "scheduled_detection_ids" {
  description = "Detection IDs deployed as scheduled queries."
  value       = keys(google_bigquery_data_transfer_config.scheduled_detection)
}

output "scheduled_detection_names" {
  description = "BigQuery Data Transfer scheduled query resource names."
  value       = { for id, config in google_bigquery_data_transfer_config.scheduled_detection : id => config.name }
}
