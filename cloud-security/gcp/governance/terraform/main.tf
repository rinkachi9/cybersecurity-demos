# GCP Organization Policies: Enterprise-Level Guardrails
# These policies enforce security standards across all projects in the Organization.

# 1. Disable Service Account Key Creation
# Prevents users from creating static JSON keys, forcing the use of WIF or IAM.
resource "google_organization_policy" "disable_sa_key_creation" {
  org_id     = "YOUR_ORG_ID"
  constraint = "constraints/iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = true
  }
}

# 2. Disable External IP Addresses for VMs
# Enforces that VMs can only have internal IPs, requiring Cloud NAT or IAP for access.
resource "google_organization_policy" "disable_external_ips" {
  org_id     = "YOUR_ORG_ID"
  constraint = "constraints/compute.restrictPublicIp"

  list_policy {
    deny {
      all = true
    }
  }
}

# 3. Enforce Uniform Bucket-Level Access (Cloud Storage)
# Eliminates complex per-object ACLs in favor of IAM-only access control.
resource "google_organization_policy" "enforce_uniform_access" {
  org_id     = "YOUR_ORG_ID"
  constraint = "constraints/storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = true
  }
}

# 4. Skip Default Network Creation
# Prevents GCP from creating the 'default' VPC (with open firewall rules) in new projects.
resource "google_organization_policy" "skip_default_network" {
  org_id     = "YOUR_ORG_ID"
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = true
  }
}

# 5. Restrict Resource Usage to Specific Regions (e.g., Europe)
# Useful for GDPR and regulatory compliance.
resource "google_organization_policy" "restrict_locations" {
  org_id     = "YOUR_ORG_ID"
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    allow {
      values = ["in:eu-locations"]
    }
  }
}
