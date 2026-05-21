variable "organization_id" {
  description = "Numeric Google Cloud organization ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{6,}$", var.organization_id))
    error_message = "organization_id must be numeric."
  }
}

variable "enforce_disable_service_account_key_creation" {
  description = "Enforce static service account key creation prevention."
  type        = bool
  default     = true
}

variable "enforce_uniform_bucket_level_access" {
  description = "Enforce uniform bucket-level access."
  type        = bool
  default     = true
}

variable "enforce_skip_default_network" {
  description = "Prevent default VPC creation in new projects."
  type        = bool
  default     = true
}

variable "allowed_resource_locations" {
  description = "Allowed organization policy resource locations."
  type        = list(string)
  default     = ["in:eu-locations"]
}
