variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "network_self_link" {
  type = string
}

variable "collector_subnetwork_self_link" {
  type = string
}

variable "health_check_name" {
  type    = string
  default = "collector-health-check"
}

variable "health_check_port" {
  type    = number
  default = 80
}

variable "collector_backend_name" {
  type    = string
  default = "ids-collector-backend"
}

variable "collector_forwarding_rule_name" {
  type    = string
  default = "mirror-collector-ilb"
}

variable "packet_mirroring_policy_name" {
  type    = string
  default = "corporate-traffic-mirror"
}

variable "packet_mirroring_policy_description" {
  type    = string
  default = "Mirror selected traffic to the security collector pool."
}

variable "mirrored_subnetwork_self_links" {
  type    = list(string)
  default = []
}

variable "mirrored_tags" {
  type    = list(string)
  default = []
}

variable "mirrored_ip_protocols" {
  type    = list(string)
  default = ["tcp", "udp", "icmp"]
}

variable "mirrored_cidr_ranges" {
  type    = list(string)
  default = ["10.0.0.0/8"]
}

variable "mirroring_direction" {
  type    = string
  default = "BOTH"
}

variable "collector_firewall_rule_name" {
  type    = string
  default = "allow-mirrored-traffic"
}

variable "collector_target_tags" {
  type    = list(string)
  default = ["ids-collector"]
}
