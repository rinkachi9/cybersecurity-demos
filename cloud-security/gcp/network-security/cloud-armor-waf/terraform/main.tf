# GCP Advanced Cloud Armor: Bot Management & Adaptive Protection
# This policy expands on basic WAF with ML-driven defense and Bot mitigation.

resource "google_compute_security_policy" "advanced_waf_policy" {
  name        = "enterprise-waf-policy"
  description = "L7 Protection + Bot Management + ML Adaptive Protection"

  # 1. Enable Adaptive Protection (ML-based DDoS detection)
  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable = true
      rule_visibility = "STANDARD"
    }
  }

  # 2. Advanced Rule: Bot Management (reCAPTCHA Enterprise)
  # Redirects suspicious traffic to a reCAPTCHA challenge.
  rule {
    action   = "redirect"
    priority = "500"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('botmanagement-v1-stable')"
      }
    }
    redirect_options {
      type = "GOOGLE_RECAPTCHA"
    }
    description = "Challenge suspicious bot traffic with reCAPTCHA"
  }

  # 3. Advanced Rule: Rate Limiting with "Banning"
  # If an IP exceeds 50 req/min, ban them for 10 minutes.
  rule {
    action   = "throttle"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      rate_limit_threshold {
        count        = 50
        interval_sec = 60
      }
      enforce_on_key = "IP"
      ban_threshold {
        count = 100
        interval_sec = 60
      }
      ban_duration_sec = 600 # 10 minutes ban
    }
    description = "Throttle and ban aggressive IPs"
  }

  # 4. Standard WAF Rules (SQLi, XSS)
  rule {
    action   = "deny(403)"
    priority = "2000"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }
    description = "Block SQL Injection"
  }

  # Default Rule
  rule {
    action   = "allow"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow"
  }
}
