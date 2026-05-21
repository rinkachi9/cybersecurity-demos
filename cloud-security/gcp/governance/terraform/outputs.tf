output "organization_id" {
  description = "Organization ID where guardrails are applied."
  value       = var.organization_id
}

output "policy_constraints" {
  description = "Organization policy constraints managed by this module."
  value = [
    google_organization_policy.disable_sa_key_creation.constraint,
    google_organization_policy.restrict_public_ip.constraint,
    google_organization_policy.uniform_bucket_level_access.constraint,
    google_organization_policy.skip_default_network.constraint,
    google_organization_policy.restrict_locations.constraint,
  ]
}
