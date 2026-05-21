resource "google_organization_policy" "disable_sa_key_creation" {
  org_id     = var.organization_id
  constraint = "constraints/iam.disableServiceAccountKeyCreation"

  boolean_policy {
    enforced = var.enforce_disable_service_account_key_creation
  }
}

resource "google_organization_policy" "restrict_public_ip" {
  org_id     = var.organization_id
  constraint = "constraints/compute.restrictPublicIp"

  list_policy {
    deny {
      all = true
    }
  }
}

resource "google_organization_policy" "uniform_bucket_level_access" {
  org_id     = var.organization_id
  constraint = "constraints/storage.uniformBucketLevelAccess"

  boolean_policy {
    enforced = var.enforce_uniform_bucket_level_access
  }
}

resource "google_organization_policy" "skip_default_network" {
  org_id     = var.organization_id
  constraint = "constraints/compute.skipDefaultNetworkCreation"

  boolean_policy {
    enforced = var.enforce_skip_default_network
  }
}

resource "google_organization_policy" "restrict_locations" {
  org_id     = var.organization_id
  constraint = "constraints/gcp.resourceLocations"

  list_policy {
    allow {
      values = var.allowed_resource_locations
    }
  }
}
