variable "project_id" {
  description = "Google Cloud project ID that owns the BigQuery security dataset."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "location" {
  description = "BigQuery dataset and scheduled query location."
  type        = string
  default     = "US"

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+$", var.location))
    error_message = "location must be a valid BigQuery location such as US, EU, or europe-west1."
  }
}

variable "dataset_id" {
  description = "BigQuery dataset ID used as the security data lake."
  type        = string
  default     = "security_data_lake"

  validation {
    condition     = can(regex("^[A-Za-z_][A-Za-z0-9_]{1,1023}$", var.dataset_id))
    error_message = "dataset_id must be a valid BigQuery dataset ID."
  }
}

variable "dataset_friendly_name" {
  description = "Human-readable BigQuery dataset name."
  type        = string
  default     = "Security Data Lake"
}

variable "dataset_description" {
  description = "BigQuery dataset description."
  type        = string
  default     = "Centralized security logs and detection outputs."
}

variable "labels" {
  description = "Labels applied to BigQuery resources."
  type        = map(string)
  default = {
    domain  = "secops"
    purpose = "security-data-lake"
  }
}

variable "kms_key_name" {
  description = "Optional Cloud KMS key name for BigQuery default encryption. Leave empty to use Google-managed encryption."
  type        = string
  default     = ""
}

variable "delete_contents_on_destroy" {
  description = "Allow Terraform destroy to delete dataset contents in sandbox environments."
  type        = bool
  default     = false
}

variable "enable_required_services" {
  description = "Enable required Google APIs from this module."
  type        = bool
  default     = false
}

variable "sink_scope" {
  description = "Scope for the log sink: organization, folder, or project."
  type        = string
  default     = "project"

  validation {
    condition     = contains(["organization", "folder", "project"], var.sink_scope)
    error_message = "sink_scope must be organization, folder, or project."
  }
}

variable "organization_id" {
  description = "Organization ID used when sink_scope is organization."
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "Folder ID used when sink_scope is folder."
  type        = string
  default     = ""
}

variable "sink_project_id" {
  description = "Optional project ID used when sink_scope is project. Defaults to project_id."
  type        = string
  default     = ""
}

variable "sink_name" {
  description = "Name of the Cloud Logging sink."
  type        = string
  default     = "centralized-security-logs-sink"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_-]{2,98}$", var.sink_name))
    error_message = "sink_name must be 3-99 characters and start with a letter."
  }
}

variable "sink_description" {
  description = "Description for the Cloud Logging sink."
  type        = string
  default     = "Exports security-relevant logs to BigQuery for detection engineering."
}

variable "include_children" {
  description = "Include child projects for organization and folder sinks."
  type        = bool
  default     = true
}

variable "use_partitioned_log_tables" {
  description = "Use partitioned BigQuery tables for Cloud Logging exports."
  type        = bool
  default     = true
}

variable "grant_log_sink_writer" {
  description = "Grant the generated log sink writer identity BigQuery data editor on the dataset."
  type        = bool
  default     = true
}

variable "log_sink_filter" {
  description = "Cloud Logging advanced filter for high-value security telemetry."
  type        = string
  default     = <<-EOT
    resource.type="gce_instance" OR
    resource.type="gcs_bucket" OR
    resource.type="cloud_run_revision" OR
    logName:"cloudaudit.googleapis.com%2Factivity" OR
    logName:"cloudaudit.googleapis.com%2Fdata_access" OR
    jsonPayload.enforcedSecurityPolicy.name:* OR
    logName:"compute.googleapis.com%2Fvpc_flows"
  EOT

  validation {
    condition     = length(trimspace(var.log_sink_filter)) > 0
    error_message = "log_sink_filter must not be empty."
  }
}

variable "enable_scheduled_detections" {
  description = "Deploy BigQuery scheduled queries for the detection-as-code rules."
  type        = bool
  default     = false
}

variable "enabled_detection_ids" {
  description = "Scheduled detection IDs to deploy when enable_scheduled_detections is true."
  type        = set(string)
  default = [
    "brute_force_login",
    "low_and_slow_beaconing",
    "gcs_data_exfiltration",
  ]

  validation {
    condition = alltrue([
      for detection_id in var.enabled_detection_ids :
      contains(["brute_force_login", "low_and_slow_beaconing", "gcs_data_exfiltration"], detection_id)
    ])
    error_message = "enabled_detection_ids may include only supported detection IDs."
  }
}

variable "detection_schedule" {
  description = "BigQuery scheduled query cadence."
  type        = string
  default     = "every 1 hours"
}

variable "scheduled_query_service_account_email" {
  description = "Optional service account email used to run scheduled queries."
  type        = string
  default     = ""

  validation {
    condition     = var.scheduled_query_service_account_email == "" || can(regex("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.gserviceaccount\\.com$", var.scheduled_query_service_account_email))
    error_message = "scheduled_query_service_account_email must be empty or a valid service account email."
  }
}
