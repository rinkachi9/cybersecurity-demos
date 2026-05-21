variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "service_name" {
  type    = string
  default = "secure-cloud-run-edge"
}

variable "runtime_service_account_id" {
  type    = string
  default = "cloud-run-edge-runtime"
}

variable "container_image" {
  type = string
}

variable "domain_names" {
  type = list(string)
}

variable "iap_oauth2_client_id" {
  type = string
}

variable "iap_oauth2_client_secret" {
  type      = string
  sensitive = true
}

variable "iap_members" {
  type = set(string)
}

variable "runtime_service_account_roles" {
  type    = set(string)
  default = []
}

variable "enable_required_services" {
  type    = bool
  default = false
}
