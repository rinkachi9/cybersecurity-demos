resource "google_data_loss_prevention_inspect_template" "pii_inspect" {
  parent       = "projects/${var.project_id}"
  display_name = var.inspect_template_display_name
  description  = "Inspect template for common PII and payment data."

  inspect_config {
    dynamic "info_types" {
      for_each = var.inspect_info_types

      content {
        name = info_types.value
      }
    }

    min_likelihood = var.min_likelihood
  }
}

resource "google_data_loss_prevention_deidentify_template" "masking_template" {
  parent       = "projects/${var.project_id}"
  display_name = var.deidentify_template_display_name
  description  = "De-identification template for masking PII in demo datasets."

  deidentify_config {
    info_type_transformations {
      transformations {
        dynamic "info_types" {
          for_each = var.masked_info_types

          content {
            name = info_types.value
          }
        }

        primitive_transformation {
          character_mask_config {
            masking_character = var.masking_character
            number_to_mask    = 0
            reverse_order     = false
          }
        }
      }

      transformations {
        info_types {
          name = "CREDIT_CARD_NUMBER"
        }

        primitive_transformation {
          replace_with_info_type_config = true
        }
      }
    }
  }
}
