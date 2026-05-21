terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "Google Cloud project ID for the minimal Cloud IDS example."
  type        = string
}

variable "region" {
  description = "Region for the minimal Cloud IDS example."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "VPC network name monitored by Cloud IDS."
  type        = string
}

variable "monitored_subnetwork_self_link" {
  description = "Subnetwork self link mirrored to Cloud IDS."
  type        = string
}

module "cloud_ids" {
  source = "../../terraform"

  project_id   = var.project_id
  region       = var.region
  network_name = var.network_name

  endpoint_name            = "minimal-cloud-ids"
  minimum_threat_severity  = "MEDIUM"
  enable_required_services = false

  enable_private_service_connection   = true
  create_reserved_peering_range       = true
  private_service_range_prefix_length = 16

  enable_packet_mirroring = true

  mirrored_subnetwork_self_links = [
    var.monitored_subnetwork_self_link,
  ]

  mirrored_cidr_ranges = ["10.0.0.0/8"]
  mirroring_direction  = "BOTH"
}

output "ids_endpoint_name" {
  description = "Cloud IDS endpoint name."
  value       = module.cloud_ids.ids_endpoint_name
}

output "packet_mirroring_policy_name" {
  description = "Packet mirroring policy name."
  value       = module.cloud_ids.packet_mirroring_policy_name
}
