terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.45"
    }
  }
}

provider "google" {
  project = var.project_id
}

variable "project_id" {
  description = "Google Cloud project ID for the minimal Cloud Armor WAF example."
  type        = string
}

module "cloud_armor_waf" {
  source = "../../terraform"

  project_id  = var.project_id
  policy_name = "minimal-secure-edge-waf"

  enable_adaptive_protection      = true
  enable_bot_management           = false
  enable_rate_limiting            = true
  rate_limit_threshold_count      = 100
  preconfigured_waf_rules_preview = false
}

output "security_policy_self_link" {
  description = "Attach this self link to a compatible backend service."
  value       = module.cloud_armor_waf.security_policy_self_link
}
