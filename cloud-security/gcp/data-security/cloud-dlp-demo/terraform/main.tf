# GCP Cloud DLP (Data Loss Prevention) Configuration
# This demo shows how to automatically identify and mask sensitive data (PII).

resource "google_data_loss_prevention_inspect_template" "pii_inspect" {
  parent       = "projects/YOUR_PROJECT_ID"
  display_name = "PII Inspect Template"

  inspect_config {
    info_types {
      name = "EMAIL_ADDRESS"
    }
    info_types {
      name = "CREDIT_CARD_NUMBER"
    }
    info_types {
      name = "PHONE_NUMBER"
    }
    info_types {
      name = "LOCATION"
    }

    min_likelihood = "LIKELY"
  }
}

resource "google_data_loss_prevention_deidentify_template" "masking_template" {
  parent       = "projects/YOUR_PROJECT_ID"
  display_name = "Masking PII Template"

  deidentify_config {
    info_type_transformations {
      transformations {
        info_types {
          name = "EMAIL_ADDRESS"
        }
        info_types {
          name = "PHONE_NUMBER"
        }
        primitive_transformation {
          character_mask_config {
            masking_character = "*"
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

output "inspect_template_id" {
  value = google_data_loss_prevention_inspect_template.pii_inspect.id
}

output "deidentify_template_id" {
  value = google_data_loss_prevention_deidentify_template.masking_template.id
}
