resource "google_compute_firewall_policy" "guardrail" {
  parent      = var.firewall_policy_parent
  short_name  = var.firewall_policy_short_name
  description = var.firewall_policy_description
}

resource "google_compute_firewall_policy_rule" "deny_external_ssh" {
  firewall_policy = google_compute_firewall_policy.guardrail.id
  description     = "Global block for external SSH access"
  priority        = var.deny_external_ssh_priority
  enable_logging  = true
  action          = "deny"
  direction       = "INGRESS"

  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["22"]
    }
    src_ip_ranges = var.external_source_ranges
  }
}

resource "google_compute_firewall" "allow_app_to_db" {
  project = var.project_id
  name    = "allow-app-to-db"
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = [var.database_port]
  }

  source_service_accounts = [var.app_service_account_email]
  target_service_accounts = [var.database_service_account_email]
}

resource "google_compute_firewall" "deny_all_ingress" {
  project  = var.project_id
  name     = "default-deny-all-ingress"
  network  = var.network_self_link
  priority = 65534

  deny {
    protocol = "all"
  }

  source_ranges = var.external_source_ranges
}
