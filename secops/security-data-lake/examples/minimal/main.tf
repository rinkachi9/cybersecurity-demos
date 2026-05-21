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
}

variable "project_id" {
  description = "Google Cloud project ID for the minimal Security Data Lake example."
  type        = string
}

module "security_data_lake" {
  source = "../../terraform"

  project_id = var.project_id
  location   = "US"

  dataset_id                 = "security_data_lake"
  sink_scope                 = "project"
  sink_project_id            = var.project_id
  enable_required_services   = false
  enable_scheduled_detections = false
  delete_contents_on_destroy = false
}

output "dataset_id" {
  description = "BigQuery dataset ID."
  value       = module.security_data_lake.dataset_id
}

output "log_sink_writer_identity" {
  description = "Generated writer identity that needs dataset write access."
  value       = module.security_data_lake.log_sink_writer_identity
}
