variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "github_organization" {
  description = "GitHub organization or user."
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name."
  type        = string
}

variable "allowed_refs" {
  description = "Allowed Git refs for OIDC tokens."
  type        = list(string)
  default     = ["refs/heads/main"]
}

variable "service_account_project_roles" {
  description = "Project-level roles for the automation service account."
  type        = set(string)
  default     = ["roles/viewer"]
}

