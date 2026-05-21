variable "project_id" {
  description = "Google Cloud project ID."
  type        = string
}

variable "region" {
  description = "Region for Secure Web Proxy resources."
  type        = string
  default     = "us-central1"
}

variable "enable_tls_inspection" {
  description = "Enable TLS inspection policy."
  type        = bool
  default     = false
}

variable "tls_inspection_policy_name" {
  description = "TLS inspection policy name."
  type        = string
  default     = "egress-tls-inspection"
}

variable "ca_pool_id" {
  description = "CA pool resource ID used by TLS inspection."
  type        = string
  default     = ""
}

variable "exclude_public_ca_set" {
  description = "Exclude public CA set from TLS inspection."
  type        = bool
  default     = true
}

variable "url_list_name" {
  description = "URL list name."
  type        = string
  default     = "approved-package-paths"
}

variable "allowed_url_patterns" {
  description = "Allowed URL patterns for Secure Web Proxy."
  type        = list(string)
  default     = ["pypi.org/project/google-cloud-storage/*", "pypi.org/project/pandas/*"]
}

variable "gateway_rule_name" {
  description = "Gateway security policy rule name."
  type        = string
  default     = "allow-approved-package-paths"
}

variable "gateway_security_policy_id" {
  description = "Gateway security policy ID."
  type        = string
}

variable "gateway_rule_priority" {
  description = "Gateway rule priority."
  type        = number
  default     = 500
}

variable "enable_firewall_plus_ips_rule" {
  description = "Create optional Cloud Firewall Plus IPS rule."
  type        = bool
  default     = false
}

variable "network_firewall_policy_id" {
  description = "Network firewall policy ID for optional IPS rule."
  type        = string
  default     = ""
}

variable "security_profile_group_id" {
  description = "Security profile group ID for optional IPS rule."
  type        = string
  default     = ""
}

variable "ips_rule_priority" {
  description = "IPS rule priority."
  type        = number
  default     = 1000
}

variable "ips_rule_direction" {
  description = "IPS rule direction."
  type        = string
  default     = "INGRESS"
}

variable "ips_rule_ports" {
  description = "TCP ports inspected by the optional IPS rule."
  type        = list(string)
  default     = ["443", "80"]
}

variable "ips_source_ranges" {
  description = "Source ranges for optional IPS rule."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
