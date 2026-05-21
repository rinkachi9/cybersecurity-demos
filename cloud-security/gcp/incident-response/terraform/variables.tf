variable "project_id" {
  description = "Google Cloud project ID for incident response resources."
  type        = string
}

variable "region" {
  description = "Cloud Functions region."
  type        = string
  default     = "us-central1"
}

variable "organization_id" {
  description = "SCC organization ID."
  type        = string
}

variable "pubsub_topic_name" {
  description = "Pub/Sub topic for SCC findings."
  type        = string
  default     = "scc-remediation-topic"
}

variable "scc_notification_config_id" {
  description = "SCC notification config ID."
  type        = string
  default     = "public-bucket-remediation"
}

variable "scc_finding_filter" {
  description = "SCC finding filter."
  type        = string
  default     = "category = \"PUBLIC_BUCKET_ACL\" AND state = \"ACTIVE\""
}

variable "function_name" {
  description = "Cloud Function remediation worker name."
  type        = string
  default     = "auto-remediate-public-bucket"
}

variable "source_archive_bucket" {
  description = "Bucket containing function source archive."
  type        = string
}

variable "source_archive_object" {
  description = "Object name for function source archive."
  type        = string
  default     = "remediator.zip"
}

variable "function_entry_point" {
  description = "Cloud Function entry point."
  type        = string
  default     = "remediate_bucket"
}

variable "dry_run" {
  description = "Keep remediation in dry-run mode."
  type        = bool
  default     = true
}

variable "grant_remediator_storage_admin" {
  description = "Grant storage.admin to the remediation function service account."
  type        = bool
  default     = false
}
