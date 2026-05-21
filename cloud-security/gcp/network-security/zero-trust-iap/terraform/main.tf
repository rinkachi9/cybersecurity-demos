resource "google_access_context_manager_access_level" "secure_context" {
  parent = var.access_policy_name
  name   = "${var.access_policy_name}/accessLevels/${var.access_level_id}"
  title  = var.access_level_title

  basic {
    combining_function = "AND"

    conditions {
      ip_subnetworks = var.trusted_ip_subnetworks
      regions        = var.trusted_regions

      device_policy {
        require_screen_lock    = var.require_screen_lock
        require_admin_approval = var.require_admin_approval

        os_constraints {
          os_type         = var.required_os_type
          minimum_version = var.minimum_os_version
        }
      }
    }
  }
}

resource "google_iap_web_backend_service_iam_member" "conditional_access" {
  for_each = var.iap_members

  project             = var.project_id
  web_backend_service = var.web_backend_service_name
  role                = "roles/iap.httpsResourceAccessor"
  member              = each.value

  condition {
    title       = var.iam_condition_title
    description = "Require Context-Aware Access level for IAP access."
    expression  = "accessContextManager.accessLevels.contains('${google_access_context_manager_access_level.secure_context.name}')"
  }
}

resource "google_access_context_manager_service_perimeter" "bridge_perimeter" {
  count = var.enable_bridge_perimeter ? 1 : 0

  parent         = var.access_policy_name
  name           = "${var.access_policy_name}/servicePerimeters/${var.bridge_perimeter_id}"
  title          = var.bridge_perimeter_title
  perimeter_type = "PERIMETER_TYPE_BRIDGE"

  status {
    resources = [
      for project_number in var.bridge_project_numbers : "projects/${project_number}"
    ]
  }
}
