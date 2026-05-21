terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
  }
}

module "github_actions_wif" {
  source = "../../terraform"

  project_id          = var.project_id
  github_organization = var.github_organization
  github_repository   = var.github_repository
  allowed_refs        = var.allowed_refs

  service_account_project_roles = var.service_account_project_roles
}

