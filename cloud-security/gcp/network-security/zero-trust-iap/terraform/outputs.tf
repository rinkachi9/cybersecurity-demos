output "access_level_name" {
  description = "Context-Aware Access level name."
  value       = google_access_context_manager_access_level.secure_context.name
}

output "iap_members" {
  description = "IAP members granted conditional access."
  value       = values(google_iap_web_backend_service_iam_member.conditional_access)[*].member
}

output "bridge_perimeter_name" {
  description = "Bridge perimeter name when enabled."
  value       = try(google_access_context_manager_service_perimeter.bridge_perimeter[0].name, null)
}
