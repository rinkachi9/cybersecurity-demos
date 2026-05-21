variable "project_id" {
  description = "Google Cloud project ID for DLP templates."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "project_id must be a valid Google Cloud project ID."
  }
}

variable "inspect_template_display_name" {
  description = "Display name for the DLP inspect template."
  type        = string
  default     = "PII Inspect Template"
}

variable "deidentify_template_display_name" {
  description = "Display name for the DLP de-identification template."
  type        = string
  default     = "Masking PII Template"
}

variable "inspect_info_types" {
  description = "DLP info types detected by the inspect template."
  type        = list(string)
  default     = ["EMAIL_ADDRESS", "CREDIT_CARD_NUMBER", "PHONE_NUMBER", "LOCATION"]
}

variable "masked_info_types" {
  description = "DLP info types masked by character replacement."
  type        = list(string)
  default     = ["EMAIL_ADDRESS", "PHONE_NUMBER"]
}

variable "min_likelihood" {
  description = "Minimum likelihood returned by the DLP inspect template."
  type        = string
  default     = "LIKELY"

  validation {
    condition     = contains(["VERY_UNLIKELY", "UNLIKELY", "POSSIBLE", "LIKELY", "VERY_LIKELY"], var.min_likelihood)
    error_message = "min_likelihood must be a valid Cloud DLP likelihood."
  }
}

variable "masking_character" {
  description = "Character used when masking selected info types."
  type        = string
  default     = "*"

  validation {
    condition     = length(var.masking_character) == 1
    error_message = "masking_character must be a single character."
  }
}
