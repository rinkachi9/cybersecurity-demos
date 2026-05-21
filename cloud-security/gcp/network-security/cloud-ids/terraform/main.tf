locals {
  network_self_link = var.network_self_link != "" ? var.network_self_link : "projects/${var.project_id}/global/networks/${var.network_name}"
  ids_location      = var.ids_location != "" ? var.ids_location : "${var.region}-a"

  required_services = toset([
    "cloudids.googleapis.com",
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
  ])

  reserved_peering_ranges = var.create_reserved_peering_range ? [google_compute_global_address.ids_peering_range[0].name] : var.existing_reserved_peering_ranges
}

resource "google_project_service" "required" {
  for_each = var.enable_required_services ? local.required_services : toset([])

  project            = var.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_compute_global_address" "ids_peering_range" {
  count = var.create_reserved_peering_range ? 1 : 0

  project       = var.project_id
  name          = var.private_service_range_name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.private_service_range_prefix_length
  network       = local.network_self_link

  depends_on = [google_project_service.required]
}

resource "google_service_networking_connection" "ids_private_service_connection" {
  count = var.enable_private_service_connection ? 1 : 0

  network                 = local.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = local.reserved_peering_ranges

  depends_on = [google_compute_global_address.ids_peering_range]
}

resource "google_cloud_ids_endpoint" "ids_endpoint" {
  project     = var.project_id
  name        = var.endpoint_name
  location    = local.ids_location
  network     = local.network_self_link
  severity    = var.minimum_threat_severity
  description = var.endpoint_description
  labels      = var.labels

  depends_on = [google_service_networking_connection.ids_private_service_connection]
}

resource "google_compute_packet_mirroring" "mirror_to_ids" {
  count = var.enable_packet_mirroring ? 1 : 0

  project     = var.project_id
  name        = var.packet_mirroring_policy_name
  description = var.packet_mirroring_policy_description
  region      = var.region

  network {
    url = local.network_self_link
  }

  collector_ilb {
    url = google_cloud_ids_endpoint.ids_endpoint.endpoint_forwarding_rule
  }

  mirrored_resources {
    dynamic "subnetworks" {
      for_each = var.mirrored_subnetwork_self_links
      iterator = subnetwork

      content {
        url = subnetwork.value
      }
    }

    dynamic "instances" {
      for_each = var.mirrored_instance_self_links
      iterator = instance

      content {
        url = instance.value
      }
    }

    tags = var.mirrored_tags
  }

  filter {
    ip_protocols = var.mirrored_ip_protocols
    cidr_ranges  = var.mirrored_cidr_ranges
    direction    = var.mirroring_direction
  }

  depends_on = [google_cloud_ids_endpoint.ids_endpoint]
}
