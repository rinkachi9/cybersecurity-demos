variable "project_id" {
  description = "Google Cloud project ID where the Workload Identity Pool and service account are created."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "github_organization" {
  description = "GitHub organization or user that owns the repository allowed to impersonate the service account."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+$", var.github_organization))
    error_message = "github_organization may contain only letters, numbers, underscores, dots, and hyphens."
  }
}

variable "github_repository" {
  description = "GitHub repository name allowed to impersonate the service account."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository may contain only letters, numbers, underscores, dots, and hyphens."
  }
}

variable "allowed_refs" {
  description = "Git refs allowed by the provider attribute condition. Use an empty list to allow any ref in the repository."
  type        = list(string)
  default     = ["refs/heads/main"]

  validation {
    condition     = alltrue([for ref in var.allowed_refs : startswith(ref, "refs/heads/") || startswith(ref, "refs/tags/")])
    error_message = "allowed_refs entries must start with refs/heads/ or refs/tags/."
  }
}

variable "workload_identity_pool_id" {
  description = "Short ID for the Workload Identity Pool."
  type        = string
  default     = "github-actions-pool"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}[a-z0-9]$", var.workload_identity_pool_id))
    error_message = "workload_identity_pool_id must be 4-32 lowercase characters, numbers, or hyphens."
  }
}

variable "workload_identity_provider_id" {
  description = "Short ID for the GitHub OIDC provider."
  type        = string
  default     = "github-provider"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,30}[a-z0-9]$", var.workload_identity_provider_id))
    error_message = "workload_identity_provider_id must be 4-32 lowercase characters, numbers, or hyphens."
  }
}

variable "service_account_id" {
  description = "Service account ID that GitHub Actions will impersonate."
  type        = string
  default     = "github-actions-automation"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.service_account_id))
    error_message = "service_account_id must be 6-30 lowercase characters, numbers, or hyphens."
  }
}

variable "service_account_display_name" {
  description = "Display name for the automation service account."
  type        = string
  default     = "GitHub Actions Automation"
}

variable "service_account_project_roles" {
  description = "Project-level IAM roles granted to the automation service account. Keep empty until a demo needs explicit permissions."
  type        = set(string)
  default     = []

  validation {
    condition     = alltrue([for role in var.service_account_project_roles : startswith(role, "roles/") || startswith(role, "projects/") || startswith(role, "organizations/")])
    error_message = "Each role must be a predefined or custom IAM role name."
  }
}

