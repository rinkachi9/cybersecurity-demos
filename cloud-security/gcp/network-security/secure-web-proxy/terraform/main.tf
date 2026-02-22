# GCP Advanced Network Security: Cloud Firewall Plus & Secure Web Proxy
# This configuration demonstrates deep-packet inspection (TLS Inspection) and IPS.

# 1. TLS Inspection Policy (The Foundation for HTTPS Visibility)
# Requires a Private CA to generate certificates "on the fly" for inspection.
resource "google_network_security_tls_inspection_policy" "inspect_egress" {
  name     = "egress-tls-inspection"
  location = "us-central1"
  ca_pool  = "projects/YOUR_PROJECT_ID/locations/us-central1/caPools/internal-ca"
  
  exclude_public_ca_set = true # Optional: Bypass inspection for sites already using trusted CAs
}

# 2. Cloud Firewall Plus: Intrusion Prevention (IPS)
# Replaces passive IDS with active prevention using Palo Alto signatures.
resource "google_compute_network_firewall_policy_rule" "ips_rule" {
  firewall_policy = "projects/YOUR_PROJECT_ID/global/firewallPolicies/corporate-plus-policy"
  priority        = 1000
  action          = "apply_security_profile_group"
  direction       = "INGRESS"
  
  security_profile_group = "projects/YOUR_PROJECT_ID/global/securityProfileGroups/ips-high-severity"

  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["443", "80"]
    }
    src_ip_ranges = ["0.0.0.0/0"]
  }
}

# 3. Secure Web Proxy: URL-Path Level Filtering
# More granular than FQDN - allows /api/v1 but blocks /api/v2.
resource "google_network_security_url_lists" "granular_pypi" {
  name        = "pypi-specific-packages"
  location    = "us-central1"
  values      = [
    "pypi.org/project/google-cloud-storage/*",
    "pypi.org/project/pandas/*"
  ]
}

# 4. SWP Rule: TLS Inspected Path Filtering
resource "google_network_security_gateway_security_policy_rule" "allow_specific_paths" {
  name                    = "allow-pypi-paths-only"
  location                = "us-central1"
  gateway_security_policy = "projects/YOUR_PROJECT_ID/locations/us-central1/gatewaySecurityPolicies/swp-policy"
  priority                = 500
  enabled                 = true
  
  # Requires TLS Inspection to be enabled on the Gateway
  tls_inspection_enabled = true
  
  session_matcher = "inUrlList(request.url, '${google_network_security_url_lists.granular_pypi.id}')"
  basic_profile   = "ALLOW"
}
