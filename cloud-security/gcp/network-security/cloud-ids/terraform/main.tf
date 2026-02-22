# GCP Cloud IDS: Network-level Intrusion Detection
# This setup creates a Cloud IDS endpoint and mirrors VPC traffic for inspection.

# 1. Private Service Connection (Required for Cloud IDS)
# IDS runs in a Google-managed project and connects back to your VPC.
resource "google_compute_global_address" "ids_range" {
  name          = "ids-peering-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
}

resource "google_service_networking_connection" "ids_peering" {
  network                 = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.ids_range.name]
}

# 2. Cloud IDS Endpoint
# Powered by Palo Alto Networks signatures.
resource "google_cloud_ids_endpoint" "ids_endpoint" {
  name     = "corporate-ids-endpoint"
  location = "us-central1-a"
  network  = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  severity = "MEDIUM" # Log all threats above Medium severity

  depends_on = [google_service_networking_connection.ids_peering]
}

# 3. Packet Mirroring Policy
# Mirrors traffic from a specific subnet or tags to the IDS endpoint.
resource "google_compute_packet_mirroring" "mirror_to_ids" {
  name        = "ids-mirror-policy"
  description = "Mirror all traffic to the IDS endpoint for deep packet inspection"
  region      = "us-central1"
  network {
    url = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  }

  collector_ilb {
    url = google_cloud_ids_endpoint.ids_endpoint.endpoint_forwarding_rule
  }

  mirrored_resources {
    subnetworks {
      url = "projects/YOUR_PROJECT_ID/regions/us-central1/subnetworks/YOUR_SUBNET"
    }
    # Alternatively, mirror specific tags
    # tags = ["secure-app"]
  }

  filter {
    ip_protocols = ["tcp", "udp", "icmp"]
    direction    = "BOTH" # Inspect ingress and egress
  }
}

output "ids_endpoint_name" {
  value = google_cloud_ids_endpoint.ids_endpoint.name
}
