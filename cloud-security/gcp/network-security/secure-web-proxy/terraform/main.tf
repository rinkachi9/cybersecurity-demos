# GCP Secure Web Proxy: Securing Egress Traffic
# This setup creates a managed proxy for FQDN-based egress filtering.

# 1. URL List (Allowlist)
# This defines the trusted external domains your internal VMs are allowed to reach.
resource "google_network_security_url_lists" "trusted_sites" {
  name        = "corporate-allowlist"
  location    = "us-central1"
  description = "A list of trusted domains for internal workloads"
  values      = [
    "*.googleapis.com",
    "*.github.com",
    "pypi.org",
    "*.debian.org"
  ]
}

# 2. Gateway Security Policy
# The core policy that dictates what is allowed and what is inspected.
resource "google_network_security_gateway_security_policy" "swp_policy" {
  name        = "secure-egress-policy"
  location    = "us-central1"
  description = "Gateway security policy for outbound traffic"
}

# 3. Policy Rule: Allow only Trusted Sites
resource "google_network_security_gateway_security_policy_rule" "allow_trusted" {
  name                    = "allow-trusted-rule"
  location                = "us-central1"
  gateway_security_policy = google_network_security_gateway_security_policy.swp_policy.name
  priority                = 1000
  enabled                 = true
  description             = "Allow traffic to domains in the allowlist"

  # Match traffic to our URL list
  session_matcher = "inUrlList(request.url, '${google_network_security_url_lists.trusted_sites.id}')"
  basic_profile   = "ALLOW"
}

# 4. Policy Rule: Deny everything else (Implicit Deny-All)
resource "google_network_security_gateway_security_policy_rule" "deny_all" {
  name                    = "deny-untrusted-rule"
  location                = "us-central1"
  gateway_security_policy = google_network_security_gateway_security_policy.swp_policy.name
  priority                = 2000
  enabled                 = true
  description             = "Explicitly deny all other traffic"
  
  session_matcher = "true" # Match everything
  basic_profile   = "DENY"
}

# 5. The Secure Web Proxy Gateway
# This is the actual proxy instance that traffic will flow through.
resource "google_network_services_gateway" "swp_gateway" {
  name        = "corporate-egress-proxy"
  location    = "us-central1"
  type        = "SECURE_WEB_PROXY"
  addresses   = ["10.128.0.99"] # Example internal IP from the VPC subnet
  ports       = [443]
  scope       = "edge" # or regional depending on needs
  network     = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  subnetwork  = "projects/YOUR_PROJECT_ID/regions/us-central1/subnetworks/YOUR_PROXY_SUBNET"
  
  gateway_security_policy = google_network_security_gateway_security_policy.swp_policy.id
}

output "swp_gateway_id" {
  value = google_network_services_gateway.swp_gateway.id
}
