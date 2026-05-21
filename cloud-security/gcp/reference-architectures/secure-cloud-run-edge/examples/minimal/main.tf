terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
  }
}

module "secure_cloud_run_edge" {
  source = "../../terraform"

  project_id                    = var.project_id
  region                        = var.region
  service_name                  = var.service_name
  runtime_service_account_id    = var.runtime_service_account_id
  container_image               = var.container_image
  domain_names                  = var.domain_names
  iap_oauth2_client_id          = var.iap_oauth2_client_id
  iap_oauth2_client_secret      = var.iap_oauth2_client_secret
  iap_members                   = var.iap_members
  enable_required_services      = var.enable_required_services
  runtime_service_account_roles = var.runtime_service_account_roles
}
