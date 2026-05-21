variable "project_id" {
  description = "Google Cloud project ID where the Cloud Armor policy is created."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "policy_name" {
  description = "Name of the Cloud Armor security policy."
  type        = string
  default     = "secure-edge-waf"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,60}[a-z0-9]$", var.policy_name))
    error_message = "policy_name must be 4-62 lowercase characters, numbers, or hyphens."
  }
}

variable "policy_description" {
  description = "Human-readable description for the security policy."
  type        = string
  default     = "Reusable Cloud Armor WAF policy with rate limiting and OWASP preconfigured rules."
}

variable "enable_adaptive_protection" {
  description = "Enable Cloud Armor Adaptive Protection L7 DDoS defense."
  type        = bool
  default     = true
}

variable "adaptive_protection_rule_visibility" {
  description = "Visibility mode for Adaptive Protection suggested rules."
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "PREMIUM"], var.adaptive_protection_rule_visibility)
    error_message = "adaptive_protection_rule_visibility must be STANDARD or PREMIUM."
  }
}

variable "enable_bot_management" {
  description = "Enable bot management challenge rule. This can require Cloud Armor Enterprise and reCAPTCHA readiness."
  type        = bool
  default     = false
}

variable "bot_management_priority" {
  description = "Priority for the optional bot management challenge rule."
  type        = number
  default     = 500

  validation {
    condition     = var.bot_management_priority > 0 && var.bot_management_priority < 1000
    error_message = "bot_management_priority must be between 1 and 999."
  }
}

variable "bot_management_preview" {
  description = "Run the bot management rule in preview mode."
  type        = bool
  default     = true
}

variable "enable_rate_limiting" {
  description = "Enable source IP rate limiting."
  type        = bool
  default     = true
}

variable "enable_rate_based_ban" {
  description = "Use rate_based_ban instead of throttle for aggressive source IPs."
  type        = bool
  default     = false
}

variable "rate_limit_priority" {
  description = "Priority for the rate limiting rule."
  type        = number
  default     = 1000

  validation {
    condition     = var.rate_limit_priority >= 1000 && var.rate_limit_priority < 2000
    error_message = "rate_limit_priority must be between 1000 and 1999."
  }
}

variable "rate_limit_source_ip_ranges" {
  description = "Source IP ranges subject to rate limiting."
  type        = list(string)
  default     = ["*"]

  validation {
    condition     = length(var.rate_limit_source_ip_ranges) > 0
    error_message = "rate_limit_source_ip_ranges must not be empty."
  }
}

variable "rate_limit_threshold_count" {
  description = "Allowed requests per interval before the exceed action is applied."
  type        = number
  default     = 100

  validation {
    condition     = var.rate_limit_threshold_count > 0
    error_message = "rate_limit_threshold_count must be greater than zero."
  }
}

variable "rate_limit_threshold_interval_sec" {
  description = "Rate limit interval in seconds."
  type        = number
  default     = 60

  validation {
    condition     = contains([10, 30, 60, 120, 180, 240, 300, 600, 900, 1200, 1800, 3600], var.rate_limit_threshold_interval_sec)
    error_message = "rate_limit_threshold_interval_sec must be a supported Cloud Armor interval."
  }
}

variable "rate_limit_exceed_action" {
  description = "Action applied after a source exceeds the rate threshold."
  type        = string
  default     = "deny(429)"

  validation {
    condition     = contains(["deny(403)", "deny(404)", "deny(429)", "deny(502)"], var.rate_limit_exceed_action)
    error_message = "rate_limit_exceed_action must be one of deny(403), deny(404), deny(429), or deny(502)."
  }
}

variable "ban_threshold_count" {
  description = "Requests per interval before a rate-based ban is applied."
  type        = number
  default     = 300
}

variable "ban_threshold_interval_sec" {
  description = "Ban threshold interval in seconds."
  type        = number
  default     = 60
}

variable "ban_duration_sec" {
  description = "Duration of a rate-based ban in seconds."
  type        = number
  default     = 600
}

variable "preconfigured_waf_rules_preview" {
  description = "Run preconfigured WAF rules in preview mode before enforcing them."
  type        = bool
  default     = false
}

variable "sqli_rule_priority" {
  description = "Priority for the SQL injection WAF rule."
  type        = number
  default     = 2000
}

variable "xss_rule_priority" {
  description = "Priority for the cross-site scripting WAF rule."
  type        = number
  default     = 2010
}

variable "lfi_rule_priority" {
  description = "Priority for the local file inclusion WAF rule."
  type        = number
  default     = 2020
}

variable "rce_rule_priority" {
  description = "Priority for the remote code execution WAF rule."
  type        = number
  default     = 2030
}

variable "sqli_rule_action" {
  description = "Action for SQL injection matches."
  type        = string
  default     = "deny(403)"

  validation {
    condition     = contains(["deny(403)", "deny(404)", "deny(502)"], var.sqli_rule_action)
    error_message = "sqli_rule_action must be deny(403), deny(404), or deny(502)."
  }
}

variable "xss_rule_action" {
  description = "Action for cross-site scripting matches."
  type        = string
  default     = "deny(403)"

  validation {
    condition     = contains(["deny(403)", "deny(404)", "deny(502)"], var.xss_rule_action)
    error_message = "xss_rule_action must be deny(403), deny(404), or deny(502)."
  }
}

variable "lfi_rule_action" {
  description = "Action for local file inclusion matches."
  type        = string
  default     = "deny(403)"

  validation {
    condition     = contains(["deny(403)", "deny(404)", "deny(502)"], var.lfi_rule_action)
    error_message = "lfi_rule_action must be deny(403), deny(404), or deny(502)."
  }
}

variable "rce_rule_action" {
  description = "Action for remote code execution matches."
  type        = string
  default     = "deny(403)"

  validation {
    condition     = contains(["deny(403)", "deny(404)", "deny(502)"], var.rce_rule_action)
    error_message = "rce_rule_action must be deny(403), deny(404), or deny(502)."
  }
}

variable "custom_rules" {
  description = "Additional CEL rules to add to the Cloud Armor policy. Keep priorities unique."
  type = list(object({
    priority    = number
    action      = string
    expression  = string
    description = string
    preview     = optional(bool, true)
  }))
  default = []

  validation {
    condition     = alltrue([for rule in var.custom_rules : rule.priority > 0 && rule.priority < 2147483647])
    error_message = "custom_rules priorities must be between 1 and 2147483646."
  }

  validation {
    condition     = alltrue([for rule in var.custom_rules : contains(["allow", "deny(403)", "deny(404)", "deny(502)"], rule.action)])
    error_message = "custom_rules actions must be allow, deny(403), deny(404), or deny(502)."
  }
}

variable "default_rule_action" {
  description = "Default policy action for traffic that does not match other rules."
  type        = string
  default     = "allow"

  validation {
    condition     = contains(["allow", "deny(403)", "deny(404)", "deny(502)"], var.default_rule_action)
    error_message = "default_rule_action must be allow, deny(403), deny(404), or deny(502)."
  }
}
