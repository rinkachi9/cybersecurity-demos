variable "project_id" {
  description = "Google Cloud project ID for the GKE service mesh cluster."
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name."
  type        = string
  default     = "security-mesh-cluster"
}

variable "location" {
  description = "GKE location."
  type        = string
  default     = "us-central1-a"
}

variable "network_self_link" {
  description = "VPC network self link."
  type        = string
}

variable "subnetwork_self_link" {
  description = "Subnetwork self link."
  type        = string
}

variable "initial_node_count" {
  description = "Initial node count for the demo cluster."
  type        = number
  default     = 1
}

variable "release_channel" {
  description = "GKE release channel."
  type        = string
  default     = "REGULAR"
}

variable "deletion_protection" {
  description = "Enable deletion protection on the GKE cluster."
  type        = bool
  default     = false
}
