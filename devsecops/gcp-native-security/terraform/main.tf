# GCP Native DevSecOps: Artifact Registry + Binary Authorization
# This demo shows how to secure the container supply chain on GCP.

# 1. Artifact Registry with Automatic Scanning
resource "google_artifact_registry_repository" "secure_repo" {
  location      = "us-central1"
  repository_id = "secure-docker-repo"
  description   = "Docker repository with vulnerability scanning"
  format        = "DOCKER"

  # Enabling Vulnerability Scanning (Requires Container Analysis API)
  # In GCP, this is managed via the 'Vulnerability Scanning' service.
}

# 2. Binary Authorization Policy
# Enforces that only signed/scanned images can run on GKE or Cloud Run.
resource "google_binary_authorization_policy" "policy" {
  description = "Block untrusted images"

  default_admission_rule {
    evaluation_mode  = "ALWAYS_DENY" # Start by denying everything
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
  }

  # Allow images only if they meet specific criteria (e.g., from a trusted registry)
  cluster_admission_rules {
    cluster = "us-central1.production-cluster"
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      google_binary_authorization_attestor.vulnerability_attestor.name
    ]
  }
}

# 3. Attestor for Vulnerability Scanning
resource "google_binary_authorization_attestor" "vulnerability_attestor" {
  name = "vuln-attestor"
  attestation_authority_note {
    note_reference = google_container_analysis_note.vuln_note.name
  }
}

resource "google_container_analysis_note" "vuln_note" {
  name = "vulnerability-scan-note"
  short_description = "Note for vulnerability scanning attestations"
  long_description  = "This note is used by our CI/CD to sign images that passed Trivy/Snyk scans."
  
  attestation_authority {
    hint {
      human_readable_name = "Vulnerability Attestor"
    }
  }
}

output "artifact_registry_url" {
  value = "us-central1-docker.pkg.dev/${var.project_id}/secure-docker-repo"
}
