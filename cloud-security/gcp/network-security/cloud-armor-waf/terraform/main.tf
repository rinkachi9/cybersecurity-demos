locals {
  preconfigured_waf_rules = {
    sql_injection = {
      expression  = "sqli-v33-stable"
      priority    = var.sqli_rule_priority
      action      = var.sqli_rule_action
      description = "Block SQL injection probes"
    }
    cross_site_scripting = {
      expression  = "xss-v33-stable"
      priority    = var.xss_rule_priority
      action      = var.xss_rule_action
      description = "Block cross-site scripting probes"
    }
    local_file_inclusion = {
      expression  = "lfi-v33-stable"
      priority    = var.lfi_rule_priority
      action      = var.lfi_rule_action
      description = "Block local file inclusion and path traversal probes"
    }
    remote_code_execution = {
      expression  = "rce-v33-stable"
      priority    = var.rce_rule_priority
      action      = var.rce_rule_action
      description = "Block remote code execution probes"
    }
  }
}

resource "google_compute_security_policy" "cloud_armor_waf" {
  name        = var.policy_name
  description = var.policy_description

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable          = var.enable_adaptive_protection
      rule_visibility = var.adaptive_protection_rule_visibility
    }
  }

  dynamic "rule" {
    for_each = var.enable_bot_management ? [1] : []

    content {
      action      = "redirect"
      priority    = var.bot_management_priority
      preview     = var.bot_management_preview
      description = "Challenge suspicious automated traffic with reCAPTCHA"

      match {
        expr {
          expression = "evaluatePreconfiguredExpr('botmanagement-v1-stable')"
        }
      }

      redirect_options {
        type = "GOOGLE_RECAPTCHA"
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_rate_limiting ? [1] : []

    content {
      action      = var.enable_rate_based_ban ? "rate_based_ban" : "throttle"
      priority    = var.rate_limit_priority
      description = "Throttle or temporarily ban aggressive source IPs"

      match {
        versioned_expr = "SRC_IPS_V1"
        config {
          src_ip_ranges = var.rate_limit_source_ip_ranges
        }
      }

      rate_limit_options {
        conform_action = "allow"
        exceed_action  = var.rate_limit_exceed_action
        enforce_on_key = "IP"

        rate_limit_threshold {
          count        = var.rate_limit_threshold_count
          interval_sec = var.rate_limit_threshold_interval_sec
        }

        dynamic "ban_threshold" {
          for_each = var.enable_rate_based_ban ? [1] : []

          content {
            count        = var.ban_threshold_count
            interval_sec = var.ban_threshold_interval_sec
          }
        }

        ban_duration_sec = var.enable_rate_based_ban ? var.ban_duration_sec : null
      }
    }
  }

  dynamic "rule" {
    for_each = local.preconfigured_waf_rules
    iterator = waf_rule

    content {
      action      = waf_rule.value.action
      priority    = waf_rule.value.priority
      preview     = var.preconfigured_waf_rules_preview
      description = waf_rule.value.description

      match {
        expr {
          expression = "evaluatePreconfiguredExpr('${waf_rule.value.expression}')"
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.custom_rules

    content {
      action      = rule.value.action
      priority    = rule.value.priority
      preview     = rule.value.preview
      description = rule.value.description

      match {
        expr {
          expression = rule.value.expression
        }
      }
    }
  }

  rule {
    action      = var.default_rule_action
    priority    = 2147483647
    description = "Default policy action"

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}
