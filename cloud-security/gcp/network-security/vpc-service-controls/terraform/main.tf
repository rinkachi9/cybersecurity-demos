# VPC Service Controls: Data Exfiltration Prevention
# This configuration creates a Service Perimeter around sensitive GCP resources.
# WARNING: Applying this in a real environment can block access if not configured correctly.

# 1. Access Policy (Container for Perimeters)
resource "google_access_context_manager_access_policy" "access_policy" {
  parent = "organizations/YOUR_ORG_ID"
  title  = "corporate-security-policy"
}

# 2. Access Level (Who can access the perimeter from outside?)
# Example: Allow access only from corporate VPN CIDRs or specific geographies.
resource "google_access_context_manager_access_level" "corporate_access" {
  parent = google_access_context_manager_access_policy.access_policy.name
  name   = "accessPolicies/${google_access_context_manager_access_policy.access_policy.name}/accessLevels/corporate_network"
  title  = "Corporate Network Access"
  
  basic {
    conditions {
      ip_subnetworks = ["203.0.113.0/24"] # Corporate Public IP Range
      regions        = ["PL", "DE"]       # Geo-restriction
    }
  }
}

# 3. Service Perimeter (The "Secure Zone")
resource "google_access_context_manager_service_perimeter" "secure_perimeter" {
  parent = google_access_context_manager_access_policy.access_policy.name
  name   = "accessPolicies/${google_access_context_manager_access_policy.access_policy.name}/servicePerimeters/secure_data_perimeter"
  title  = "Secure Data Perimeter"
  
  status {
    # Resources inside the perimeter (protected)
    restricted_services = [
      "storage.googleapis.com", # Cloud Storage
      "bigquery.googleapis.com" # BigQuery
    ]

    # Projects inside the perimeter
    resources = [
      "projects/YOUR_PROJECT_NUMBER"
    ]

    # Allow access from the defined Access Level
    access_levels = [
      google_access_context_manager_access_level.corporate_access.name
    ]

    # Egress Policies (Allow data to leave only to specific destinations)
    egress_policies {
      egress_from {
        identities = ["serviceAccount:data-pipeline@YOUR_PROJECT_ID.iam.gserviceaccount.com"]
      }
      egress_to {
        resources = ["projects/EXTERNAL_TRUSTED_PROJECT_NUMBER"]
        operations {
          service_name = "storage.googleapis.com"
          method_selectors {
            method = "google.storage.objects.create"
          }
        }
      }
    }
  }
}
