locals {
  github_repository_full = "${var.github_organization}/${var.github_repository}"
  allowed_refs_condition = length(var.allowed_refs) == 0 ? "true" : "assertion.ref in [${join(", ", [for ref in var.allowed_refs : "\"${ref}\""])}]"
  attribute_condition    = "assertion.repository == \"${local.github_repository_full}\" && assertion.repository_owner == \"${var.github_organization}\" && ${local.allowed_refs_condition}"
}

resource "google_iam_workload_identity_pool" "github" {
  workload_identity_pool_id = var.workload_identity_pool_id
  display_name              = "GitHub Actions Pool"
  description               = "Federated identities for GitHub Actions automation."
}

resource "google_iam_workload_identity_pool_provider" "github" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = var.workload_identity_provider_id
  display_name                       = "GitHub OIDC Provider"
  description                        = "Restricts GitHub OIDC tokens to the approved repository and refs."
  attribute_condition                = local.attribute_condition

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.ref"              = "assertion.ref"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
    "attribute.workflow"         = "assertion.workflow"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_actions" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
  description  = "Keyless automation identity for ${local.github_repository_full}."
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/${local.github_repository_full}"
}

resource "google_project_iam_member" "automation_roles" {
  for_each = var.service_account_project_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

