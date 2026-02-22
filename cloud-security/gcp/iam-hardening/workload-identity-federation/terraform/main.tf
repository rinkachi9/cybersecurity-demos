# Google Cloud Workload Identity Federation for GitHub Actions
# This Terraform configuration sets up keyless authentication between GitHub Actions and GCP.

resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for GitHub Actions automation"
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"
  
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Service Account that GitHub Actions will impersonate
resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-automation"
  display_name = "Service Account for GitHub Actions"
}

# Allow GitHub Actions to impersonate the Service Account
# Filtered by specific repository for security
resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/YOUR_ORG/YOUR_REPO"
}

output "workload_identity_provider_name" {
  value = google_iam_workload_identity_pool_provider.github_provider.name
  description = "The full identifier of the Workload Identity Provider"
}

output "service_account_email" {
  value = google_service_account.github_actions_sa.email
}
