variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "pubsub_topic_name" {
  type    = string
  default = "scc-leaked-keys"
}

variable "workflow_service_account_id" {
  type    = string
  default = "soar-workflow-sa"
}

variable "trigger_service_account_id" {
  type    = string
  default = "soar-trigger-sa"
}

variable "function_source_bucket" {
  type = string
}

variable "enrichment_source_object" {
  type    = string
  default = "enrichment.zip"
}

variable "remediation_source_object" {
  type    = string
  default = "remediation.zip"
}

variable "enrichment_function_name" {
  type    = string
  default = "soar-enrichment-worker"
}

variable "remediation_function_name" {
  type    = string
  default = "soar-remediation-worker"
}

variable "workflow_name" {
  type    = string
  default = "leaked-key-response-playbook"
}

variable "eventarc_trigger_name" {
  type    = string
  default = "trigger-soar-on-finding"
}

variable "dry_run" {
  type    = bool
  default = true
}
