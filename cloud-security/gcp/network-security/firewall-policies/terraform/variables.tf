variable "project_id" {
  description = "Google Cloud project ID for VPC firewall rules."
  type        = string
}

variable "firewall_policy_parent" {
  description = "Parent resource for hierarchical firewall policy, for example folders/123456789."
  type        = string

  validation {
    condition     = can(regex("^(folders|organizations)/[0-9]+$", var.firewall_policy_parent))
    error_message = "firewall_policy_parent must look like folders/123456789 or organizations/123456789."
  }
}

variable "firewall_policy_short_name" {
  description = "Hierarchical firewall policy short name."
  type        = string
  default     = "global-security-policy"
}

variable "firewall_policy_description" {
  description = "Hierarchical firewall policy description."
  type        = string
  default     = "Corporate-wide firewall policy for internal VPCs."
}

variable "network_self_link" {
  description = "VPC network self link."
  type        = string
}

variable "external_source_ranges" {
  description = "External source ranges denied by guardrails."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "deny_external_ssh_priority" {
  description = "Priority for the external SSH deny rule."
  type        = number
  default     = 1000
}

variable "database_port" {
  description = "Database port allowed from app identity to database identity."
  type        = string
  default     = "5432"
}

variable "app_service_account_email" {
  description = "Source application service account email."
  type        = string
}

variable "database_service_account_email" {
  description = "Target database service account email."
  type        = string
}
