resource "google_compute_region_health_check" "collector_hc" {
  project = var.project_id
  name    = var.health_check_name
  region  = var.region

  tcp_health_check {
    port = var.health_check_port
  }
}

resource "google_compute_region_backend_service" "collector_backend" {
  project               = var.project_id
  name                  = var.collector_backend_name
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  protocol              = "TCP"
  health_checks         = [google_compute_region_health_check.collector_hc.id]
}

resource "google_compute_forwarding_rule" "mirror_collector_ilb" {
  project                 = var.project_id
  name                    = var.collector_forwarding_rule_name
  region                  = var.region
  load_balancing_scheme   = "INTERNAL"
  backend_service         = google_compute_region_backend_service.collector_backend.id
  all_ports               = true
  network                 = var.network_self_link
  subnetwork              = var.collector_subnetwork_self_link
  is_mirroring_collector  = true
}

resource "google_compute_packet_mirroring" "security_mirror_policy" {
  project     = var.project_id
  name        = var.packet_mirroring_policy_name
  description = var.packet_mirroring_policy_description
  region      = var.region

  network {
    url = var.network_self_link
  }

  collector_ilb {
    url = google_compute_forwarding_rule.mirror_collector_ilb.id
  }

  mirrored_resources {
    dynamic "subnetworks" {
      for_each = var.mirrored_subnetwork_self_links

      content {
        url = subnetworks.value
      }
    }

    tags = var.mirrored_tags
  }

  filter {
    ip_protocols = var.mirrored_ip_protocols
    cidr_ranges  = var.mirrored_cidr_ranges
    direction    = var.mirroring_direction
  }
}

resource "google_compute_firewall" "allow_mirrored_traffic" {
  project = var.project_id
  name    = var.collector_firewall_rule_name
  network = var.network_self_link

  allow {
    protocol = "all"
  }

  source_ranges = var.mirrored_cidr_ranges
  target_tags   = var.collector_target_tags
}
