output "security_policy_name" {
  description = "Cloud Armor security policy name."
  value       = google_compute_security_policy.cloud_armor_waf.name
}

output "security_policy_id" {
  description = "Cloud Armor security policy ID."
  value       = google_compute_security_policy.cloud_armor_waf.id
}

output "security_policy_self_link" {
  description = "Self link used when attaching the policy to a backend service."
  value       = google_compute_security_policy.cloud_armor_waf.self_link
}

output "security_policy_fingerprint" {
  description = "Fingerprint of the Cloud Armor policy."
  value       = google_compute_security_policy.cloud_armor_waf.fingerprint
}

output "preconfigured_waf_rule_priorities" {
  description = "Priority map for the built-in preconfigured WAF rules."
  value       = { for name, rule in local.preconfigured_waf_rules : name => rule.priority }
}

output "rate_limiting_enabled" {
  description = "Whether the rate limiting rule is enabled."
  value       = var.enable_rate_limiting
}

output "adaptive_protection_enabled" {
  description = "Whether Adaptive Protection is enabled."
  value       = var.enable_adaptive_protection
}
