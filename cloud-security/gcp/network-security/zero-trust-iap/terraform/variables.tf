variable "project_id" {
  type = string
}

variable "access_policy_name" {
  type = string
}

variable "access_level_id" {
  type    = string
  default = "secure_corporate_context"
}

variable "access_level_title" {
  type    = string
  default = "Secure Corporate Access"
}

variable "trusted_ip_subnetworks" {
  type    = list(string)
  default = ["203.0.113.0/24"]
}

variable "trusted_regions" {
  type    = list(string)
  default = ["US"]
}

variable "require_screen_lock" {
  type    = bool
  default = true
}

variable "require_admin_approval" {
  type    = bool
  default = true
}

variable "required_os_type" {
  type    = string
  default = "DESKTOP_CHROME_OS"
}

variable "minimum_os_version" {
  type    = string
  default = "114.0.0"
}

variable "web_backend_service_name" {
  type = string
}

variable "iap_members" {
  type = set(string)
}

variable "iam_condition_title" {
  type    = string
  default = "Secure Device Only"
}

variable "enable_bridge_perimeter" {
  type    = bool
  default = false
}

variable "bridge_perimeter_id" {
  type    = string
  default = "prod_to_analytics_bridge"
}

variable "bridge_perimeter_title" {
  type    = string
  default = "Production to Analytics Bridge"
}

variable "bridge_project_numbers" {
  type    = list(string)
  default = []
}
