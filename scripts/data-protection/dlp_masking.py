import google.cloud.dlp
import os

# Google Cloud DLP Demo: Masking PII (Personally Identifiable Information)
# This script demonstrates how to identify and mask sensitive data using Cloud DLP API.

def mask_sensitive_data(project_id, text):
    dlp = google.cloud.dlp_v2.DlpServiceClient()

    # The content to inspect
    item = {"value": text}

    # The info types to look for (PII)
    inspect_config = {
        "info_types": [
            {"name": "EMAIL_ADDRESS"},
            {"name": "PHONE_NUMBER"},
            {"name": "CREDIT_CARD_NUMBER"},
            {"name": "LOCATION"}
        ],
        "min_likelihood": google.cloud.dlp_v2.Likelihood.LIKELY,
    }

    # The transformation: masking with "*"
    deidentify_config = {
        "info_type_transformations": {
            "transformations": [
                {
                    "primitive_transformation": {
                        "character_mask_config": {"masking_character": "*"}
                    }
                }
            ]
        }
    }

    parent = f"projects/{project_id}/locations/global"

    response = dlp.deidentify_content(
        request={
            "parent": parent,
            "deidentify_config": deidentify_config,
            "inspect_config": inspect_config,
            "item": item,
        }
    )

    return response.item.value

if __name__ == "__main__":
    PROJECT_ID = os.getenv("GCP_PROJECT_ID", "YOUR_PROJECT_ID")
    SAMPLE_TEXT = "My data: john.doe@gmail.com, phone: 555-444-333, card: 1234-5678-9012-3456"

    print(f"--- Original text ---\n{SAMPLE_TEXT}")
    
    # In a real-world scenario, we would call the actual API.
    print("\n--- After Anonymization (Cloud DLP Simulation) ---")
    
    # Simulating output for the demo:
    print("My data: *********@gmail.com, phone: ***********, card: [CREDIT_CARD_NUMBER]")
