output "pubsub_topic_id" {
  description = "Pub/Sub topic ID."
  value       = google_pubsub_topic.scc_findings.id
}

output "workflow_name" {
  description = "SOAR workflow name."
  value       = google_workflows_workflow.soar_playbook.name
}

output "dry_run" {
  description = "Whether SOAR remediation is configured as dry-run."
  value       = var.dry_run
}
