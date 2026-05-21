output "custom_role_name" {
  description = "Created custom role name."
  value       = google_project_iam_custom_role.security_auditor_custom.name
}

output "security_auditor_group" {
  description = "Group bound to the custom auditor role."
  value       = var.security_auditor_group
}
