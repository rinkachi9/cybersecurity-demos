# GCP Advanced IAM: Custom Roles, Groups, and Least Privilege
# This setup demonstrates managing identities and access at an enterprise level.

# 1. Custom Role Creation
# Predefined roles are often too broad. Senior architects create custom roles 
# to follow the Principle of Least Privilege (PoLP).
resource "google_project_iam_custom_role" "security_auditor_custom" {
  role_id     = "corporateSecurityAuditor"
  title       = "Corporate Security Auditor (Custom)"
  description = "A granular role for security auditing with read-only access to critical logs and configs."
  permissions = [
    "compute.instances.get",
    "compute.instances.list",
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "logging.logEntries.list",
    "iam.roles.get",
    "resourcemanager.projects.getIamPolicy"
  ]
}

# 2. IAM Binding for a Security Group
# NOTE: In a real environment, groups are usually managed via Cloud Identity or Google Workspace.
# This binding grants the custom role to an entire group of users.
resource "google_project_iam_member" "group_auditor_binding" {
  project = "YOUR_PROJECT_ID"
  role    = google_project_iam_custom_role.security_auditor_custom.id
  member  = "group:security-auditors@yourdomain.com"
}

# 3. IAM Member for an Individual User (Standard Role)
# Granting a predefined role to a specific user for operational tasks.
resource "google_project_iam_member" "user_compute_viewer" {
  project = "YOUR_PROJECT_ID"
  role    = "roles/compute.viewer"
  member  = "user:john.doe@yourdomain.com"
}

# 4. Resource-Level IAM (Granular Access)
# Instead of project-wide access, we grant permission only to a specific resource (e.g., a GCS Bucket).
resource "google_storage_bucket_iam_member" "specific_bucket_reader" {
  bucket = "your-sensitive-data-bucket"
  role   = "roles/storage.objectViewer"
  member = "group:data-analysts@yourdomain.com"
}

# 5. Conditional IAM (Context-Aware Access)
# Grant access only if a specific condition is met (e.g., specific time or request IP).
resource "google_project_iam_member" "temporary_dev_access" {
  project = "YOUR_PROJECT_ID"
  role    = "roles/compute.admin"
  member  = "user:dev-on-call@yourdomain.com"

  condition {
    title       = "Expiring access"
    description = "Expires at the end of 2026"
    expression  = "request.time < timestamp("2027-01-01T00:00:00Z")"
  }
}

output "custom_role_name" {
  value = google_project_iam_custom_role.security_auditor_custom.name
}
