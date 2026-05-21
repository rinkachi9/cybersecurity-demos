variable "project_id" {
  description = "Google Cloud project ID where IAM bindings are applied."
  type        = string
}

variable "custom_role_id" {
  description = "Custom role ID for the security auditor role."
  type        = string
  default     = "corporateSecurityAuditor"
}

variable "custom_role_title" {
  description = "Custom role title."
  type        = string
  default     = "Corporate Security Auditor"
}

variable "custom_role_permissions" {
  description = "Permissions granted to the custom security auditor role."
  type        = list(string)
  default = [
    "compute.instances.get",
    "compute.instances.list",
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "logging.logEntries.list",
    "iam.roles.get",
    "resourcemanager.projects.getIamPolicy",
  ]
}

variable "security_auditor_group" {
  description = "Cloud Identity group receiving the custom auditor role."
  type        = string

  validation {
    condition     = can(regex("^group:", var.security_auditor_group))
    error_message = "security_auditor_group must use the group: prefix."
  }
}

variable "compute_viewer_members" {
  description = "Members granted compute.viewer."
  type        = set(string)
  default     = []
}

variable "sensitive_bucket_name" {
  description = "Bucket receiving resource-level object viewer bindings."
  type        = string
}

variable "bucket_reader_members" {
  description = "Members granted object viewer on the sensitive bucket."
  type        = set(string)
  default     = []
}

variable "temporary_compute_admin_members" {
  description = "Members granted time-bound compute.admin."
  type        = set(string)
  default     = []
}

variable "temporary_access_expires_at" {
  description = "RFC3339 timestamp for temporary compute admin expiry."
  type        = string
  default     = "2027-01-01T00:00:00Z"
}
