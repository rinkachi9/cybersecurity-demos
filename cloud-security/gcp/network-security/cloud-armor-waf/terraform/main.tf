# GCP Secure Web Stack: Load Balancer + Cloud Armor + Cloud Run
# This project demonstrates a production-ready edge security architecture.

# 1. External Global Static IP
resource "google_compute_global_address" "lb_ip" {
  name = "web-stack-ip"
}

# 2. Cloud Armor Security Policy (WAF)
resource "google_compute_security_policy" "waf_policy" {
  name        = "secure-edge-waf"
  description = "OWASP Top 10 Protection + Rate Limiting"

  # Rule: SQL Injection
  rule {
    action   = "deny(403)"
    priority = "1000"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }
    description = "Block SQL Injection"
  }

  # Rule: Cross-Site Scripting (XSS)
  rule {
    action   = "deny(403)"
    priority = "1001"
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-v33-stable')"
      }
    }
    description = "Block XSS"
  }

  # Rule: Rate Limiting (Prevent Brute Force/DDoS)
  rule {
    action   = "throttle"
    priority = "2000"
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
        count        = 100
        interval_sec = 60
      }
      enforce_on_key = "IP"
    }
    description = "Rate limit to 100 requests per minute per IP"
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

# 3. Cloud Run Service (The protected application)
resource "google_cloud_run_service" "app" {
  name     = "secure-app-service"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello" # Placeholder image
      }
    }
  }

  metadata {
    annotations = {
      # Only allow traffic from the Load Balancer (Internal Ingress)
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }
}

# 4. Serverless NEG (Connects Cloud Run to LB)
resource "google_compute_region_network_endpoint_group" "serverless_neg" {
  name                  = "serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_run {
    service = google_cloud_run_service.app.name
  }
}

# 5. Backend Service (Linking NEG + WAF)
resource "google_compute_backend_service" "default" {
  name                    = "web-backend"
  protocol                = "HTTP"
  load_balancing_scheme   = "EXTERNAL_MANAGED"
  security_policy         = google_compute_security_policy.waf_policy.id

  backend {
    group = google_compute_region_network_endpoint_group.serverless_neg.id
  }
}

# 6. URL Map + Proxy + Forwarding Rule (LB Plumbing)
resource "google_compute_url_map" "default" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "web-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "web-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.lb_ip.id
}

output "load_balancer_ip" {
  value = google_compute_global_address.lb_ip.address
}
