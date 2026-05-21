variable "project_id" {
  description = "Google Cloud project ID for the reference architecture."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "Region for Cloud Run and the serverless NEG."
  type        = string
  default     = "us-central1"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "region must look like us-central1 or europe-west1."
  }
}

variable "service_name" {
  description = "Cloud Run service name."
  type        = string
  default     = "secure-cloud-run-edge"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,48}[a-z0-9]$", var.service_name))
    error_message = "service_name must be 4-50 lowercase characters, numbers, or hyphens."
  }
}

variable "runtime_service_account_id" {
  description = "Service account ID for the Cloud Run runtime identity."
  type        = string
  default     = "cloud-run-edge-runtime"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.runtime_service_account_id))
    error_message = "runtime_service_account_id must be 6-30 lowercase characters, numbers, or hyphens."
  }
}

variable "container_image" {
  description = "Container image deployed to Cloud Run."
  type        = string

  validation {
    condition     = length(var.container_image) > 0 && !can(regex(":latest$", var.container_image))
    error_message = "container_image must be set and should not use the floating latest tag."
  }
}

variable "container_port" {
  description = "Container port exposed by the Cloud Run service."
  type        = number
  default     = 8080

  validation {
    condition     = var.container_port > 0 && var.container_port < 65536
    error_message = "container_port must be a valid TCP port."
  }
}

variable "domain_names" {
  description = "Domain names for the managed SSL certificate."
  type        = list(string)

  validation {
    condition     = length(var.domain_names) > 0 && alltrue([for domain in var.domain_names : can(regex("^[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$", domain))])
    error_message = "domain_names must contain at least one valid DNS name."
  }
}

variable "iap_oauth2_client_id" {
  description = "OAuth2 client ID used by IAP for the backend service."
  type        = string
}

variable "iap_oauth2_client_secret" {
  description = "OAuth2 client secret used by IAP for the backend service."
  type        = string
  sensitive   = true
}

variable "iap_members" {
  description = "IAM members allowed through IAP, for example group:security@example.com."
  type        = set(string)

  validation {
    condition     = length(var.iap_members) > 0 && alltrue([for member in var.iap_members : can(regex("^(user|group|serviceAccount|domain):", member))])
    error_message = "iap_members must contain at least one valid IAM member."
  }
}

variable "runtime_service_account_roles" {
  description = "Optional project-level IAM roles for the Cloud Run runtime service account."
  type        = set(string)
  default     = []

  validation {
    condition     = alltrue([for role in var.runtime_service_account_roles : startswith(role, "roles/") || startswith(role, "projects/") || startswith(role, "organizations/")])
    error_message = "Runtime roles must be predefined or custom IAM role names."
  }
}

variable "security_policy_name" {
  description = "Cloud Armor security policy name."
  type        = string
  default     = "secure-cloud-run-edge"
}

variable "rate_limit_threshold" {
  description = "Allowed requests per minute per source IP before throttling."
  type        = number
  default     = 100
}

variable "log_sample_rate" {
  description = "Backend service log sample rate."
  type        = number
  default     = 1.0

  validation {
    condition     = var.log_sample_rate >= 0 && var.log_sample_rate <= 1
    error_message = "log_sample_rate must be between 0 and 1."
  }
}

variable "enable_required_services" {
  description = "Enable required Google APIs from this module."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Cloud Run deletion protection."
  type        = bool
  default     = false
}
