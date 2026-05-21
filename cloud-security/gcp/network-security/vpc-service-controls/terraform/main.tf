locals {
  access_policy_name = var.create_access_policy ? google_access_context_manager_access_policy.this[0].name : var.access_policy_name

  protected_resources = [
    for project_number in var.protected_project_numbers : "projects/${project_number}"
  ]

  current_enforced_resources = [
    for project_number in var.current_enforced_project_numbers : "projects/${project_number}"
  ]

  desired_access_levels = concat(
    tolist(var.extra_access_level_names),
    google_access_context_manager_access_level.trusted[*].name,
  )

  effective_status_restricted_services = var.enforcement_mode == "enforced" ? var.restricted_services : var.current_enforced_restricted_services
  effective_status_resources           = var.enforcement_mode == "enforced" ? local.protected_resources : local.current_enforced_resources
  effective_status_access_levels       = var.enforcement_mode == "enforced" ? local.desired_access_levels : tolist(var.current_enforced_access_level_names)
  effective_status_egress_policies     = var.enforcement_mode == "enforced" ? var.egress_policies : var.current_enforced_egress_policies
  effective_status_ingress_policies    = var.enforcement_mode == "enforced" ? var.ingress_policies : var.current_enforced_ingress_policies
}

resource "google_access_context_manager_access_policy" "this" {
  count = var.create_access_policy ? 1 : 0

  parent = "organizations/${var.organization_id}"
  title  = var.access_policy_title
}

resource "google_access_context_manager_access_level" "trusted" {
  count = var.create_trusted_access_level ? 1 : 0

  parent = local.access_policy_name
  name   = "${local.access_policy_name}/accessLevels/${var.trusted_access_level_id}"
  title  = var.trusted_access_level_title

  basic {
    combining_function = "AND"

    conditions {
      ip_subnetworks = var.trusted_ip_subnetworks
      regions        = var.trusted_regions
      members        = var.trusted_members
      negate         = false
    }
  }
}

resource "google_access_context_manager_service_perimeter" "this" {
  parent = local.access_policy_name
  name   = "${local.access_policy_name}/servicePerimeters/${var.perimeter_id}"
  title  = var.perimeter_title

  perimeter_type                = "PERIMETER_TYPE_REGULAR"
  use_explicit_dry_run_spec     = var.enforcement_mode == "dry-run"
  description                   = var.perimeter_description

  status {
    restricted_services = local.effective_status_restricted_services
    resources           = local.effective_status_resources
    access_levels       = local.effective_status_access_levels

    dynamic "egress_policies" {
      for_each = local.effective_status_egress_policies
      iterator = egress_policy

      content {
        egress_from {
          identities = egress_policy.value.identities
        }

        egress_to {
          resources = [
            for project_number in egress_policy.value.destination_project_numbers : "projects/${project_number}"
          ]

          dynamic "operations" {
            for_each = egress_policy.value.operations
            iterator = operation

            content {
              service_name = operation.value.service_name

              dynamic "method_selectors" {
                for_each = operation.value.methods
                iterator = method

                content {
                  method = method.value
                }
              }
            }
          }
        }
      }
    }

    dynamic "ingress_policies" {
      for_each = local.effective_status_ingress_policies
      iterator = ingress_policy

      content {
        ingress_from {
          identities = ingress_policy.value.identities

          dynamic "sources" {
            for_each = concat(
              [for project_number in ingress_policy.value.source_project_numbers : { resource = "projects/${project_number}", access_level = null }],
              [for access_level in ingress_policy.value.source_access_levels : { resource = null, access_level = access_level }],
            )
            iterator = source

            content {
              resource     = source.value.resource
              access_level = source.value.access_level
            }
          }
        }

        ingress_to {
          resources = [
            for project_number in ingress_policy.value.destination_project_numbers : "projects/${project_number}"
          ]

          dynamic "operations" {
            for_each = ingress_policy.value.operations
            iterator = operation

            content {
              service_name = operation.value.service_name

              dynamic "method_selectors" {
                for_each = operation.value.methods
                iterator = method

                content {
                  method = method.value
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "spec" {
    for_each = var.enforcement_mode == "dry-run" ? [1] : []

    content {
      restricted_services = var.restricted_services
      resources           = local.protected_resources
      access_levels       = local.desired_access_levels

      dynamic "egress_policies" {
        for_each = var.egress_policies
        iterator = egress_policy

        content {
          egress_from {
            identities = egress_policy.value.identities
          }

          egress_to {
            resources = [
              for project_number in egress_policy.value.destination_project_numbers : "projects/${project_number}"
            ]

            dynamic "operations" {
              for_each = egress_policy.value.operations
              iterator = operation

              content {
                service_name = operation.value.service_name

                dynamic "method_selectors" {
                  for_each = operation.value.methods
                  iterator = method

                  content {
                    method = method.value
                  }
                }
              }
            }
          }
        }
      }

      dynamic "ingress_policies" {
        for_each = var.ingress_policies
        iterator = ingress_policy

        content {
          ingress_from {
            identities = ingress_policy.value.identities

            dynamic "sources" {
              for_each = concat(
                [for project_number in ingress_policy.value.source_project_numbers : { resource = "projects/${project_number}", access_level = null }],
                [for access_level in ingress_policy.value.source_access_levels : { resource = null, access_level = access_level }],
              )
              iterator = source

              content {
                resource     = source.value.resource
                access_level = source.value.access_level
              }
            }
          }

          ingress_to {
            resources = [
              for project_number in ingress_policy.value.destination_project_numbers : "projects/${project_number}"
            ]

            dynamic "operations" {
              for_each = ingress_policy.value.operations
              iterator = operation

              content {
                service_name = operation.value.service_name

                dynamic "method_selectors" {
                  for_each = operation.value.methods
                  iterator = method

                  content {
                    method = method.value
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
