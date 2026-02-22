# GKE Service Mesh Security: Mesh-enabled Cluster
# This configuration shows how to enable Service Mesh functionality for Zero Trust microservices.

# 1. GKE Cluster with Workload Identity (Prerequisite for Mesh)
resource "google_container_cluster" "mesh_cluster" {
  name     = "security-mesh-cluster"
  location = "us-central1-a"

  # Enabling Workload Identity for identity-based security
  workload_identity_config {
    workload_pool = "YOUR_PROJECT_ID.svc.id.goog"
  }

  # Enabling GKE Dataplane V2 (for native NetworkPolicies and Performance)
  datapath_provider = "ADVANCED_DATAPATH"

  # Initial node count
  initial_node_count = 1
}

# 2. Enabling Anthos Service Mesh (Managed Istio)
# Note: In a real environment, this is often enabled via 'gcloud container fleet'
# or a specific Terraform module for ASM.
output "gke_mesh_instructions" {
  value = "To enable ASM, use: gcloud container fleet mesh enable --project=YOUR_PROJECT_ID"
}

# 3. Secure Ingress Gateway (The Front Door)
# This would typically involve a Load Balancer pointing to the Istio Ingress Gateway.
