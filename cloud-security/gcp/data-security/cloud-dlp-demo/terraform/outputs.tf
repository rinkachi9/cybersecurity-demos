output "inspect_template_id" {
  description = "Cloud DLP inspect template ID."
  value       = google_data_loss_prevention_inspect_template.pii_inspect.id
}

output "deidentify_template_id" {
  description = "Cloud DLP de-identification template ID."
  value       = google_data_loss_prevention_deidentify_template.masking_template.id
}
