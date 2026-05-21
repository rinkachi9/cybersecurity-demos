output "workload_identity_provider_name" {
  description = "GitHub Actions auth provider value."
  value       = module.github_actions_wif.workload_identity_provider_name
}

output "service_account_email" {
  description = "GitHub Actions service account value."
  value       = module.github_actions_wif.service_account_email
}

output "attribute_condition" {
  description = "Provider condition restricting accepted GitHub OIDC tokens."
  value       = module.github_actions_wif.attribute_condition
}

