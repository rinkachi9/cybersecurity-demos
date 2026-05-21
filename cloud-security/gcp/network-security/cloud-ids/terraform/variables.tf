variable "project_id" {
  description = "Google Cloud project ID where Cloud IDS is deployed."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "region" {
  description = "Region for packet mirroring and the default IDS zone."
  type        = string
  default     = "us-central1"

  validation {
    condition     = can(regex("^[a-z]+-[a-z]+[0-9]$", var.region))
    error_message = "region must look like us-central1 or europe-west1."
  }
}

variable "ids_location" {
  description = "Zone for the Cloud IDS endpoint. Leave empty to use <region>-a."
  type        = string
  default     = ""

  validation {
    condition     = var.ids_location == "" || can(regex("^[a-z]+-[a-z]+[0-9]-[a-z]$", var.ids_location))
    error_message = "ids_location must be empty or a valid zone such as us-central1-a."
  }
}

variable "network_name" {
  description = "VPC network name used when network_self_link is not provided."
  type        = string
  default     = "security-monitoring-vpc"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,61}[a-z0-9]$", var.network_name))
    error_message = "network_name must be a valid VPC network name."
  }
}

variable "network_self_link" {
  description = "Full VPC network self link. Overrides network_name when set."
  type        = string
  default     = ""
}

variable "endpoint_name" {
  description = "Cloud IDS endpoint name."
  type        = string
  default     = "corporate-ids-endpoint"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,61}[a-z0-9]$", var.endpoint_name))
    error_message = "endpoint_name must be 4-63 lowercase characters, numbers, or hyphens."
  }
}

variable "endpoint_description" {
  description = "Cloud IDS endpoint description."
  type        = string
  default     = "Managed Cloud IDS endpoint for mirrored VPC traffic inspection."
}

variable "minimum_threat_severity" {
  description = "Minimum Cloud IDS threat severity that generates findings."
  type        = string
  default     = "MEDIUM"

  validation {
    condition     = contains(["INFORMATIONAL", "LOW", "MEDIUM", "HIGH", "CRITICAL"], var.minimum_threat_severity)
    error_message = "minimum_threat_severity must be INFORMATIONAL, LOW, MEDIUM, HIGH, or CRITICAL."
  }
}

variable "labels" {
  description = "Labels applied to Cloud IDS resources that support labels."
  type        = map(string)
  default = {
    domain  = "network-security"
    control = "cloud-ids"
  }
}

variable "enable_required_services" {
  description = "Enable required Google APIs from this module."
  type        = bool
  default     = false
}

variable "enable_private_service_connection" {
  description = "Create the Service Networking connection required by Cloud IDS."
  type        = bool
  default     = true
}

variable "create_reserved_peering_range" {
  description = "Create a reserved VPC peering range for Service Networking."
  type        = bool
  default     = true
}

variable "private_service_range_name" {
  description = "Name for the reserved private service range."
  type        = string
  default     = "ids-peering-address"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,61}[a-z0-9]$", var.private_service_range_name))
    error_message = "private_service_range_name must be 4-63 lowercase characters, numbers, or hyphens."
  }
}

variable "private_service_range_prefix_length" {
  description = "Prefix length for the reserved private service range."
  type        = number
  default     = 16

  validation {
    condition     = var.private_service_range_prefix_length >= 16 && var.private_service_range_prefix_length <= 24
    error_message = "private_service_range_prefix_length must be between 16 and 24."
  }
}

variable "existing_reserved_peering_ranges" {
  description = "Existing reserved peering range names used when create_reserved_peering_range is false."
  type        = list(string)
  default     = []
}

variable "enable_packet_mirroring" {
  description = "Create a packet mirroring policy to send selected traffic to Cloud IDS."
  type        = bool
  default     = true
}

variable "packet_mirroring_policy_name" {
  description = "Packet mirroring policy name."
  type        = string
  default     = "ids-mirror-policy"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,61}[a-z0-9]$", var.packet_mirroring_policy_name))
    error_message = "packet_mirroring_policy_name must be 4-63 lowercase characters, numbers, or hyphens."
  }
}

variable "packet_mirroring_policy_description" {
  description = "Packet mirroring policy description."
  type        = string
  default     = "Mirror selected traffic to Cloud IDS for deep packet inspection."
}

variable "mirrored_subnetwork_self_links" {
  description = "Subnetwork self links mirrored to Cloud IDS."
  type        = list(string)
  default     = []
}

variable "mirrored_instance_self_links" {
  description = "Compute instance self links mirrored to Cloud IDS."
  type        = list(string)
  default     = []
}

variable "mirrored_tags" {
  description = "Network tags mirrored to Cloud IDS."
  type        = list(string)
  default     = []
}

variable "mirrored_ip_protocols" {
  description = "IP protocols mirrored to Cloud IDS."
  type        = list(string)
  default     = ["tcp", "udp", "icmp"]

  validation {
    condition     = length(var.mirrored_ip_protocols) > 0
    error_message = "mirrored_ip_protocols must not be empty."
  }
}

variable "mirrored_cidr_ranges" {
  description = "CIDR ranges mirrored to Cloud IDS. Use a constrained range in production."
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = length(var.mirrored_cidr_ranges) > 0
    error_message = "mirrored_cidr_ranges must not be empty."
  }
}

variable "mirroring_direction" {
  description = "Traffic direction mirrored to Cloud IDS."
  type        = string
  default     = "BOTH"

  validation {
    condition     = contains(["INGRESS", "EGRESS", "BOTH"], var.mirroring_direction)
    error_message = "mirroring_direction must be INGRESS, EGRESS, or BOTH."
  }
}
