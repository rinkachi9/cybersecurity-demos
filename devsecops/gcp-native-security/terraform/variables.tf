variable "project_id" {
  description = "Google Cloud project ID for supply-chain controls."
  type        = string
}

variable "region" {
  description = "Artifact Registry location."
  type        = string
  default     = "us-central1"
}

variable "repository_id" {
  description = "Artifact Registry repository ID."
  type        = string
  default     = "secure-docker-repo"
}

variable "attestor_name" {
  description = "Binary Authorization attestor name."
  type        = string
  default     = "vuln-attestor"
}

variable "attestation_note_name" {
  description = "Container Analysis note name."
  type        = string
  default     = "vulnerability-scan-note"
}

variable "attestation_human_readable_name" {
  description = "Human-readable attestation note name."
  type        = string
  default     = "Vulnerability Attestor"
}

variable "default_evaluation_mode" {
  description = "Default Binary Authorization evaluation mode."
  type        = string
  default     = "ALWAYS_DENY"
}

variable "default_enforcement_mode" {
  description = "Default Binary Authorization enforcement mode."
  type        = string
  default     = "ENFORCED_BLOCK_AND_AUDIT_LOG"
}

variable "cluster_admission_rules" {
  description = "Cluster-specific admission rules requiring attestation."
  type = list(object({
    cluster          = string
    enforcement_mode = string
  }))
  default = []
}

variable "labels" {
  description = "Labels applied to Artifact Registry."
  type        = map(string)
  default = {
    domain  = "devsecops"
    control = "supply-chain"
  }
}
