terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
  }
}

provider "google" {}

variable "organization_id" {
  description = "Numeric Google Cloud organization ID."
  type        = string
}

variable "access_policy_name" {
  description = "Existing Access Context Manager policy name, for example accessPolicies/123456789012."
  type        = string
}

variable "protected_project_number" {
  description = "Sandbox project number to protect in dry-run mode."
  type        = string
}

module "vpc_service_controls" {
  source = "../../terraform"

  organization_id    = var.organization_id
  access_policy_name = var.access_policy_name

  enforcement_mode = "dry-run"

  protected_project_numbers = [
    var.protected_project_number,
  ]

  restricted_services = [
    "bigquery.googleapis.com",
    "storage.googleapis.com",
  ]

  trusted_ip_subnetworks = [
    "203.0.113.0/24",
  ]

  trusted_regions = [
    "PL",
  ]
}

output "service_perimeter_name" {
  description = "Created dry-run service perimeter name."
  value       = module.vpc_service_controls.service_perimeter_name
}

output "dry_run_spec_enabled" {
  description = "Confirms the desired policy is configured as dry-run."
  value       = module.vpc_service_controls.dry_run_spec_enabled
}
