output "url_list_id" {
  description = "Secure Web Proxy URL list ID."
  value       = google_network_security_url_lists.allowed_package_paths.id
}

output "gateway_rule_id" {
  description = "Gateway security policy rule ID."
  value       = google_network_security_gateway_security_policy_rule.allow_specific_paths.id
}

output "tls_inspection_policy_id" {
  description = "TLS inspection policy ID when enabled."
  value       = try(google_network_security_tls_inspection_policy.inspect_egress[0].id, null)
}
