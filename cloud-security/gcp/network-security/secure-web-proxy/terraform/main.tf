resource "google_network_security_tls_inspection_policy" "inspect_egress" {
  count = var.enable_tls_inspection ? 1 : 0

  project               = var.project_id
  name                  = var.tls_inspection_policy_name
  location              = var.region
  ca_pool               = var.ca_pool_id
  exclude_public_ca_set = var.exclude_public_ca_set
}

resource "google_network_security_url_lists" "allowed_package_paths" {
  project  = var.project_id
  name     = var.url_list_name
  location = var.region
  values   = var.allowed_url_patterns
}

resource "google_network_security_gateway_security_policy_rule" "allow_specific_paths" {
  project                 = var.project_id
  name                    = var.gateway_rule_name
  location                = var.region
  gateway_security_policy = var.gateway_security_policy_id
  priority                = var.gateway_rule_priority
  enabled                 = true

  tls_inspection_enabled = var.enable_tls_inspection
  session_matcher        = "inUrlList(request.url, '${google_network_security_url_lists.allowed_package_paths.id}')"
  basic_profile          = "ALLOW"
}

resource "google_compute_network_firewall_policy_rule" "ips_rule" {
  count = var.enable_firewall_plus_ips_rule ? 1 : 0

  firewall_policy        = var.network_firewall_policy_id
  priority               = var.ips_rule_priority
  action                 = "apply_security_profile_group"
  direction              = var.ips_rule_direction
  security_profile_group = var.security_profile_group_id

  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = var.ips_rule_ports
    }
    src_ip_ranges = var.ips_source_ranges
  }
}
