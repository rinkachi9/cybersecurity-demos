output "artifact_registry_url" {
  description = "Artifact Registry Docker repository URL."
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.secure_repo.repository_id}"
}

output "attestor_name" {
  description = "Binary Authorization attestor name."
  value       = google_binary_authorization_attestor.vulnerability_attestor.name
}

output "binary_authorization_policy_id" {
  description = "Binary Authorization policy ID."
  value       = google_binary_authorization_policy.policy.id
}
