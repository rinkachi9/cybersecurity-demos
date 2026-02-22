# GCP Identity-Aware Proxy (IAP) Configuration
# This demo shows how to protect an internal application with IAP (Zero Trust).

# 1. Enable IAP on the Backend Service
# (Assumes a Load Balancer and Backend Service already exist)
# resource "google_compute_backend_service" "internal_app" {
#   name                  = "internal-app-backend"
#   load_balancing_scheme = "EXTERNAL"
#   protocol              = "HTTPS"
#   
#   iap {
#     oauth2_client_id     = var.iap_client_id
#     oauth2_client_secret = var.iap_client_secret
#   }
# }

# 2. Grant Access via IAM (The only way to reach the app)
resource "google_iap_web_iam_member" "access_for_admins" {
  project = "YOUR_PROJECT_ID"
  role    = "roles/iap.httpsResourceAccessor"
  member  = "group:security-admins@yourdomain.com"
  
  # Optional: Condition to allow access only from specific IPs or during specific times
  # condition {
  #   title       = "Office IPs Only"
  #   expression  = "accessContextManager.grant_viewer_from_office_ips"
  # }
}

output "iap_protected_resource" {
  value = "Access to the internal app is now strictly controlled by Google IAM."
}
