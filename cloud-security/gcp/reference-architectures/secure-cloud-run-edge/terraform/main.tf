locals {
  required_services = [
    "compute.googleapis.com",
    "iap.googleapis.com",
    "run.googleapis.com",
  ]
}

resource "google_project_service" "required" {
  for_each = var.enable_required_services ? toset(local.required_services) : toset([])

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_service_account" "runtime" {
  account_id   = var.runtime_service_account_id
  display_name = "Cloud Run runtime for ${var.service_name}"
  description  = "Least-privilege runtime identity for the Secure Cloud Run Edge reference architecture."

  depends_on = [google_project_service.required]
}

resource "google_project_iam_member" "runtime_roles" {
  for_each = var.runtime_service_account_roles

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.runtime.email}"
}

resource "google_cloud_run_v2_service" "app" {
  name                = var.service_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
  deletion_protection = var.deletion_protection

  template {
    service_account = google_service_account.runtime.email

    containers {
      image = var.container_image

      ports {
        container_port = var.container_port
      }
    }
  }

  depends_on = [google_project_service.required]
}

resource "google_cloud_run_v2_service_iam_member" "load_balancer_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_compute_region_network_endpoint_group" "serverless" {
  name                  = "${var.service_name}-neg"
  region                = var.region
  network_endpoint_type = "SERVERLESS"

  cloud_run {
    service = google_cloud_run_v2_service.app.name
  }
}

resource "google_compute_security_policy" "edge" {
  name        = var.security_policy_name
  description = "Cloud Armor policy for Secure Cloud Run Edge."

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable          = true
      rule_visibility = "STANDARD"
    }
  }

  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('sqli-v33-stable')"
      }
    }
    description = "Block SQL injection probes."
  }

  rule {
    action   = "deny(403)"
    priority = 1010
    match {
      expr {
        expression = "evaluatePreconfiguredExpr('xss-v33-stable')"
      }
    }
    description = "Block reflected XSS probes."
  }

  rule {
    action   = "throttle"
    priority = 2000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny(429)"
      enforce_on_key = "IP"

      rate_limit_threshold {
        count        = var.rate_limit_threshold
        interval_sec = 60
      }
    }
    description = "Throttle aggressive clients by source IP."
  }

  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow after explicit WAF and rate-limit controls."
  }
}

resource "google_compute_backend_service" "edge" {
  name                  = "${var.service_name}-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  security_policy       = google_compute_security_policy.edge.id

  backend {
    group = google_compute_region_network_endpoint_group.serverless.id
  }

  log_config {
    enable      = true
    sample_rate = var.log_sample_rate
  }

  iap {
    enabled              = true
    oauth2_client_id     = var.iap_oauth2_client_id
    oauth2_client_secret = var.iap_oauth2_client_secret
  }
}

resource "google_iap_web_backend_service_iam_member" "accessors" {
  for_each = var.iap_members

  project             = var.project_id
  web_backend_service = google_compute_backend_service.edge.name
  role                = "roles/iap.httpsResourceAccessor"
  member              = each.value
}

resource "google_compute_global_address" "edge" {
  name = "${var.service_name}-ip"
}

resource "google_compute_managed_ssl_certificate" "edge" {
  name = "${var.service_name}-cert"

  managed {
    domains = var.domain_names
  }
}

resource "google_compute_url_map" "https" {
  name            = "${var.service_name}-https"
  default_service = google_compute_backend_service.edge.id
}

resource "google_compute_target_https_proxy" "edge" {
  name             = "${var.service_name}-https-proxy"
  url_map          = google_compute_url_map.https.id
  ssl_certificates = [google_compute_managed_ssl_certificate.edge.id]
}

resource "google_compute_global_forwarding_rule" "https" {
  name                  = "${var.service_name}-https"
  target                = google_compute_target_https_proxy.edge.id
  ip_address            = google_compute_global_address.edge.address
  port_range            = "443"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}

resource "google_compute_url_map" "http_redirect" {
  name = "${var.service_name}-http-redirect"

  default_url_redirect {
    https_redirect = true
    strip_query    = false
  }
}

resource "google_compute_target_http_proxy" "redirect" {
  name    = "${var.service_name}-http-proxy"
  url_map = google_compute_url_map.http_redirect.id
}

resource "google_compute_global_forwarding_rule" "http" {
  name                  = "${var.service_name}-http"
  target                = google_compute_target_http_proxy.redirect.id
  ip_address            = google_compute_global_address.edge.address
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"
}
