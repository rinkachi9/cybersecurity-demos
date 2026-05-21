output "firewall_policy_id" {
  description = "Hierarchical firewall policy ID."
  value       = google_compute_firewall_policy.guardrail.id
}

output "deny_external_ssh_rule_priority" {
  description = "Priority of the global external SSH deny rule."
  value       = google_compute_firewall_policy_rule.deny_external_ssh.priority
}
