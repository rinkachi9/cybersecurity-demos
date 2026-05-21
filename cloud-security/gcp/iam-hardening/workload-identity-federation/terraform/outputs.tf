output "workload_identity_pool_name" {
  description = "Full resource name of the Workload Identity Pool."
  value       = google_iam_workload_identity_pool.github.name
}

output "workload_identity_provider_name" {
  description = "Full provider name used by google-github-actions/auth."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "service_account_email" {
  description = "Email of the service account impersonated by GitHub Actions."
  value       = google_service_account.github_actions.email
}

output "github_repository_full" {
  description = "Repository allowed by the provider attribute condition."
  value       = local.github_repository_full
}

output "attribute_condition" {
  description = "CEL expression restricting accepted GitHub OIDC tokens."
  value       = local.attribute_condition
}

