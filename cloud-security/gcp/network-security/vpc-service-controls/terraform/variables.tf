variable "organization_id" {
  description = "Google Cloud organization ID that owns the Access Context Manager policy."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{6,}$", var.organization_id))
    error_message = "organization_id must be a numeric Google Cloud organization ID."
  }
}

variable "create_access_policy" {
  description = "Create an Access Context Manager access policy. Most organizations already have one, so this defaults to false."
  type        = bool
  default     = false
}

variable "access_policy_name" {
  description = "Existing Access Context Manager policy name, for example accessPolicies/123456789. Required when create_access_policy is false."
  type        = string
  default     = ""

  validation {
    condition     = var.access_policy_name == "" || can(regex("^accessPolicies/[0-9]+$", var.access_policy_name))
    error_message = "access_policy_name must be empty or look like accessPolicies/123456789."
  }
}

variable "access_policy_title" {
  description = "Title for a newly created access policy."
  type        = string
  default     = "corporate-security-policy"
}

variable "perimeter_id" {
  description = "Short service perimeter ID."
  type        = string
  default     = "secure_data_perimeter"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{2,62}$", var.perimeter_id))
    error_message = "perimeter_id must be 3-63 characters and use letters, numbers, or underscores."
  }
}

variable "perimeter_title" {
  description = "Human-readable service perimeter title."
  type        = string
  default     = "Secure Data Perimeter"
}

variable "perimeter_description" {
  description = "Service perimeter description."
  type        = string
  default     = "Dry-run first VPC Service Controls perimeter for sensitive data services."
}

variable "enforcement_mode" {
  description = "Perimeter mode. dry-run writes desired policy to spec and leaves status on current enforced config. enforced writes desired policy to status."
  type        = string
  default     = "dry-run"

  validation {
    condition     = contains(["dry-run", "enforced"], var.enforcement_mode)
    error_message = "enforcement_mode must be dry-run or enforced."
  }
}

variable "protected_project_numbers" {
  description = "Project numbers that should be protected by the desired perimeter spec."
  type        = list(string)

  validation {
    condition     = length(var.protected_project_numbers) > 0 && alltrue([for project_number in var.protected_project_numbers : can(regex("^[0-9]+$", project_number))])
    error_message = "protected_project_numbers must contain at least one numeric project number."
  }
}

variable "restricted_services" {
  description = "Google APIs restricted by the desired service perimeter."
  type        = list(string)
  default = [
    "bigquery.googleapis.com",
    "storage.googleapis.com",
  ]

  validation {
    condition     = length(var.restricted_services) > 0 && alltrue([for service in var.restricted_services : can(regex("^[a-z0-9.-]+\\.googleapis\\.com$", service))])
    error_message = "restricted_services must contain Google API service names."
  }
}

variable "create_trusted_access_level" {
  description = "Create an access level for trusted source context."
  type        = bool
  default     = true
}

variable "trusted_access_level_id" {
  description = "Short ID for the trusted access level."
  type        = string
  default     = "corporate_network"

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{2,62}$", var.trusted_access_level_id))
    error_message = "trusted_access_level_id must be 3-63 characters and use letters, numbers, or underscores."
  }
}

variable "trusted_access_level_title" {
  description = "Human-readable title for the trusted access level."
  type        = string
  default     = "Corporate Network Access"
}

variable "trusted_ip_subnetworks" {
  description = "Trusted source IP CIDR ranges for the generated access level."
  type        = list(string)
  default     = ["203.0.113.0/24"]

  validation {
    condition     = length(var.trusted_ip_subnetworks) > 0
    error_message = "trusted_ip_subnetworks must contain at least one CIDR range."
  }
}

variable "trusted_regions" {
  description = "Trusted source regions for the generated access level."
  type        = list(string)
  default     = ["PL", "DE"]

  validation {
    condition     = alltrue([for region in var.trusted_regions : can(regex("^[A-Z]{2}$", region))])
    error_message = "trusted_regions must contain ISO 3166-1 alpha-2 country codes."
  }
}

variable "trusted_members" {
  description = "Optional IAM members allowed by the generated access level."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for member in var.trusted_members : can(regex("^(user|group|serviceAccount):", member))])
    error_message = "trusted_members must use user:, group:, or serviceAccount: prefixes."
  }
}

variable "extra_access_level_names" {
  description = "Existing access level names to allow into the desired perimeter."
  type        = set(string)
  default     = []

  validation {
    condition     = alltrue([for access_level in var.extra_access_level_names : can(regex("^accessPolicies/[0-9]+/accessLevels/[A-Za-z][A-Za-z0-9_]+$", access_level))])
    error_message = "extra_access_level_names must be full access level resource names."
  }
}

variable "egress_policies" {
  description = "Desired egress exceptions from protected resources to trusted destination projects and methods."
  type = list(object({
    identities                   = list(string)
    destination_project_numbers  = list(string)
    operations = list(object({
      service_name = string
      methods      = list(string)
    }))
  }))
  default = []

  validation {
    condition     = alltrue([for policy in var.egress_policies : length(policy.identities) > 0 && length(policy.destination_project_numbers) > 0 && length(policy.operations) > 0])
    error_message = "egress_policies entries must include identities, destination_project_numbers, and operations."
  }
}

variable "ingress_policies" {
  description = "Desired ingress exceptions from external identities or source projects into protected resources."
  type = list(object({
    identities                  = list(string)
    source_project_numbers      = optional(list(string), [])
    source_access_levels        = optional(list(string), [])
    destination_project_numbers = list(string)
    operations = list(object({
      service_name = string
      methods      = list(string)
    }))
  }))
  default = []

  validation {
    condition     = alltrue([for policy in var.ingress_policies : length(policy.identities) > 0 && length(policy.destination_project_numbers) > 0 && length(policy.operations) > 0])
    error_message = "ingress_policies entries must include identities, destination_project_numbers, and operations."
  }
}

variable "current_enforced_project_numbers" {
  description = "Existing enforced perimeter projects kept in status while evaluating dry-run spec."
  type        = list(string)
  default     = []
}

variable "current_enforced_restricted_services" {
  description = "Existing enforced restricted services kept in status while evaluating dry-run spec."
  type        = list(string)
  default     = []
}

variable "current_enforced_access_level_names" {
  description = "Existing enforced access levels kept in status while evaluating dry-run spec."
  type        = set(string)
  default     = []
}

variable "current_enforced_egress_policies" {
  description = "Existing enforced egress policies kept in status while evaluating dry-run spec."
  type = list(object({
    identities                   = list(string)
    destination_project_numbers  = list(string)
    operations = list(object({
      service_name = string
      methods      = list(string)
    }))
  }))
  default = []
}

variable "current_enforced_ingress_policies" {
  description = "Existing enforced ingress policies kept in status while evaluating dry-run spec."
  type = list(object({
    identities                  = list(string)
    source_project_numbers      = optional(list(string), [])
    source_access_levels        = optional(list(string), [])
    destination_project_numbers = list(string)
    operations = list(object({
      service_name = string
      methods      = list(string)
    }))
  }))
  default = []
}
