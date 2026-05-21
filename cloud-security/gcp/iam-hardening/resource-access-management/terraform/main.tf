resource "google_project_iam_custom_role" "security_auditor_custom" {
  project     = var.project_id
  role_id     = var.custom_role_id
  title       = var.custom_role_title
  description = "Least-privilege read-only role for security auditing."
  permissions = var.custom_role_permissions
}

resource "google_project_iam_member" "group_auditor_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.security_auditor_custom.id
  member  = var.security_auditor_group
}

resource "google_project_iam_member" "compute_viewers" {
  for_each = var.compute_viewer_members

  project = var.project_id
  role    = "roles/compute.viewer"
  member  = each.value
}

resource "google_storage_bucket_iam_member" "specific_bucket_readers" {
  for_each = var.bucket_reader_members

  bucket = var.sensitive_bucket_name
  role   = "roles/storage.objectViewer"
  member = each.value
}

resource "google_project_iam_member" "temporary_dev_access" {
  for_each = var.temporary_compute_admin_members

  project = var.project_id
  role    = "roles/compute.admin"
  member  = each.value

  condition {
    title       = "Expiring access"
    description = "Temporary break-glass access with explicit expiry"
    expression  = "request.time < timestamp(\"${var.temporary_access_expires_at}\")"
  }
}
