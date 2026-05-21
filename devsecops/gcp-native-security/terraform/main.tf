resource "google_artifact_registry_repository" "secure_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for signed and scanned artifacts."
  format        = "DOCKER"
  labels        = var.labels
}

resource "google_binary_authorization_attestor" "vulnerability_attestor" {
  project = var.project_id
  name    = var.attestor_name

  attestation_authority_note {
    note_reference = google_container_analysis_note.vulnerability_note.name
  }
}

resource "google_container_analysis_note" "vulnerability_note" {
  project           = var.project_id
  name              = var.attestation_note_name
  short_description = "Vulnerability scanning attestation note"
  long_description  = "Used by CI/CD to attest images that pass SBOM and vulnerability gates."

  attestation_authority {
    hint {
      human_readable_name = var.attestation_human_readable_name
    }
  }
}

resource "google_binary_authorization_policy" "policy" {
  project     = var.project_id
  description = "Require trusted attestations for protected deployment targets."

  default_admission_rule {
    evaluation_mode  = var.default_evaluation_mode
    enforcement_mode = var.default_enforcement_mode
  }

  dynamic "cluster_admission_rules" {
    for_each = var.cluster_admission_rules

    content {
      cluster                 = cluster_admission_rules.value.cluster
      evaluation_mode         = "REQUIRE_ATTESTATION"
      enforcement_mode        = cluster_admission_rules.value.enforcement_mode
      require_attestations_by = [google_binary_authorization_attestor.vulnerability_attestor.name]
    }
  }
}
