# GCP Identity-Aware Proxy (IAP) with Context-Aware Access (CAA)
# This setup enforces Zero Trust access based on identity and device context.

# 1. Access Level Definition (Advanced)
# Users must be in the US, on a managed device, and have an encrypted disk.
resource "google_access_context_manager_access_level" "secure_context" {
  parent = "accessPolicies/YOUR_ORG_POLICY_ID"
  name   = "accessPolicies/YOUR_ORG_POLICY_ID/accessLevels/secure_corporate_context"
  title  = "Secure Corporate Access"

  basic {
    conditions {
      ip_subnetworks = ["203.0.113.0/24"] # Trusted Corporate IP
      regions        = ["US"]             # Geo-restriction
      device_policy {
        require_screen_lock = true
        require_admin_approval = true
        os_constraints {
          os_type = "DESKTOP_CHROME_OS"
          minimum_version = "114.0.0"
        }
      }
    }
    combining_function = "AND"
  }
}

# 2. Granting IAP Access with the Condition
# Access to the Backend Service is ONLY allowed if the Secure Context is met.
resource "google_iap_web_backend_service_iam_member" "conditional_access" {
  project = "YOUR_PROJECT_ID"
  web_backend_service = "your-backend-service"
  role    = "roles/iap.httpsResourceAccessor"
  member  = "user:john.doe@yourdomain.com"

  # The key Zero Trust bridge: Linking IAM with Context-Aware Access
  condition {
    title       = "Secure Device Only"
    expression  = "accessContextManager.grant_viewer_from_secure_corporate_context"
  }
}

# --- VPC Service Controls Bridge (Advanced) ---
# Allows two isolated perimeters to securely share data (e.g., Prod and Analytics).

resource "google_access_context_manager_service_perimeter" "bridge_perimeter" {
  parent = "accessPolicies/YOUR_ORG_POLICY_ID"
  name   = "accessPolicies/YOUR_ORG_POLICY_ID/servicePerimeters/prod_to_analytics_bridge"
  title  = "Production to Analytics Bridge"
  perimeter_type = "PERIMETER_TYPE_BRIDGE"

  status {
    # Linking two isolated perimeters together
    resources = [
      "projects/PRODUCTION_PROJECT_NUMBER",
      "projects/ANALYTICS_PROJECT_NUMBER"
    ]
  }
}
