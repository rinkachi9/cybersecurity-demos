# GCP Packet Mirroring: Full Traffic Visibility for NDR
# This setup mirrors VPC traffic to a pool of collector VMs behind an Internal Load Balancer.

# 1. Internal Load Balancer (The Collector Endpoint)
# Traffic from the mirrored sources is sent to this ILB.
resource "google_compute_region_backend_service" "collector_backend" {
  name                  = "ids-collector-backend"
  region                = "us-central1"
  load_balancing_scheme = "INTERNAL"
  protocol              = "TCP" # Mirroring supports TCP, UDP, ICMP
  
  # Health check for the collector VMs (Suricata/Zeek instances)
  health_checks = [google_compute_region_health_check.collector_hc.id]
}

resource "google_compute_region_health_check" "collector_hc" {
  name   = "collector-health-check"
  region = "us-central1"
  tcp_health_check {
    port = "80" # Example port where a health agent is running
  }
}

resource "google_compute_forwarding_rule" "mirror_collector_ilb" {
  name                  = "mirror-collector-ilb"
  region                = "us-central1"
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_backend_service.collector_backend.id
  all_ports             = true # Mirroring needs to capture all ports
  network               = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  subnetwork            = "projects/YOUR_PROJECT_ID/regions/us-central1/subnetworks/YOUR_COLLECTOR_SUBNET"
  
  # Required for Packet Mirroring: set the purpose to 'PRIVATE_SERVICE_CONNECT' or 'INTERNAL'
  # and ensure it's compatible with packet mirroring.
  is_mirroring_collector = true 
}

# 2. Packet Mirroring Policy
# This policy captures traffic from a source (subnet or tags) and sends it to the ILB.
resource "google_compute_packet_mirroring" "security_mirror_policy" {
  name        = "corporate-traffic-mirror"
  description = "Mirror all traffic from production subnet to the security collector pool"
  region      = "us-central1"
  
  network {
    url = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  }

  collector_ilb {
    url = google_compute_forwarding_rule.mirror_collector_ilb.id
  }

  mirrored_resources {
    subnetworks {
      url = "projects/YOUR_PROJECT_ID/regions/us-central1/subnetworks/PRODUCTION_SUBNET"
    }
    # Or mirror specific instances by tag:
    # tags = ["critical-app"]
  }

  filter {
    ip_protocols = ["tcp", "udp", "icmp"]
    direction    = "BOTH" # Mirrored ingress and egress
  }
}

# 3. Firewall Rule: Allow mirrored traffic to reach the collectors
resource "google_compute_firewall" "allow_mirrored_traffic" {
  name    = "allow-mirrored-traffic"
  network = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"

  allow {
    protocol = "all"
  }

  # Only allow traffic from the mirrored subnet to the collectors
  source_ranges = ["10.1.0.0/24"] # Example Production Subnet
  target_tags   = ["ids-collector"]
}

output "packet_mirroring_policy_id" {
  value = google_compute_packet_mirroring.security_mirror_policy.id
}
