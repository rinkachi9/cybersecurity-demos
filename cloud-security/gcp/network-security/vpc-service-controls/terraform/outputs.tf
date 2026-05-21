output "access_policy_name" {
  description = "Access Context Manager policy name used by the module."
  value       = local.access_policy_name
}

output "trusted_access_level_name" {
  description = "Generated trusted access level name, if enabled."
  value       = try(google_access_context_manager_access_level.trusted[0].name, null)
}

output "service_perimeter_name" {
  description = "VPC Service Controls service perimeter resource name."
  value       = google_access_context_manager_service_perimeter.this.name
}

output "service_perimeter_title" {
  description = "VPC Service Controls service perimeter title."
  value       = google_access_context_manager_service_perimeter.this.title
}

output "enforcement_mode" {
  description = "Configured enforcement mode."
  value       = var.enforcement_mode
}

output "dry_run_spec_enabled" {
  description = "Whether the desired perimeter is configured as an explicit dry-run spec."
  value       = var.enforcement_mode == "dry-run"
}

output "protected_resources" {
  description = "Desired protected project resource names."
  value       = local.protected_resources
}

output "restricted_services" {
  description = "Desired restricted Google APIs."
  value       = var.restricted_services
}
