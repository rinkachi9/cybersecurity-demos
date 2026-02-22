# GCP Cloud Firewall: Hierarchical Policies & VPC Rules
# This setup demonstrates enterprise-wide network protection.

# 1. Hierarchical Firewall Policy (Folder or Org level)
# This rule applies to all VPCs in a specific folder, ensuring 
# global security guardrails without manual VPC-by-VPC configuration.
resource "google_compute_firewall_policy" "org_guardrail" {
  parent      = "folders/YOUR_FOLDER_ID"
  short_name  = "global-security-policy"
  description = "Corporate-wide firewall policy for all internal VPCs"
}

# 2. Hierarchical Rule: Block all SSH from external world
# This ensures that no project can accidentally open SSH (22) to the internet.
resource "google_compute_firewall_policy_rule" "deny_external_ssh" {
  firewall_policy = google_compute_firewall_policy.org_guardrail.id
  description     = "Global block for external SSH access"
  priority        = 1000
  enable_logging  = true
  action          = "deny"
  direction       = "INGRESS"

  match {
    layer4_configs {
      ip_protocol = "tcp"
      ports       = ["22"]
    }
    src_ip_ranges = ["0.0.0.0/0"]
  }
}

# 3. VPC Firewall Rule: Identity-based (Service Accounts)
# Instead of using brittle IP addresses or Network Tags, we use Service Accounts.
# This means only a specific "backend" identity can talk to the "database".
resource "google_compute_firewall" "allow_app_to_db" {
  name    = "allow-app-to-db"
  network = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"

  allow {
    protocol = "tcp"
    ports    = ["5432"] # PostgreSQL
  }

  # SOURCE: Only the 'app-engine' service account can initiate the connection
  source_service_accounts = ["app-engine@YOUR_PROJECT_ID.iam.gserviceaccount.com"]

  # TARGET: Only the 'database' service account will accept the connection
  target_service_accounts = ["cloud-sql-proxy@YOUR_PROJECT_ID.iam.gserviceaccount.com"]
}

# 4. Cloud Firewall Plus: FQDN Filtering (Egress)
# Allows traffic to specific external domains while blocking everything else.
# (Requires Cloud Firewall Plus licensing)
# resource "google_compute_network_firewall_policy_rule" "allow_google_apis" {
#   firewall_policy = google_compute_network_firewall_policy.vpc_policy.id
#   priority        = 1500
#   action          = "allow"
#   direction       = "EGRESS"
#   match {
#     dest_fqdns = ["*.googleapis.com", "*.github.com"]
#     layer4_configs {
#       ip_protocol = "tcp"
#       ports       = ["443"]
#     }
#   }
# }

# 5. Default Deny-All Ingress (VPC Level)
# The gold standard: explicitly deny all traffic that hasn't been allowed.
resource "google_compute_firewall" "deny_all_ingress" {
  name     = "default-deny-all-ingress"
  network  = "projects/YOUR_PROJECT_ID/global/networks/YOUR_VPC"
  priority = 65534 # Low priority, acts as a fallback

  deny {
    protocol = "all"
  }
  
  source_ranges = ["0.0.0.0/0"]
}

output "firewall_policy_id" {
  value = google_compute_firewall_policy.org_guardrail.id
}
