output "cluster_name" {
  description = "GKE cluster name."
  value       = google_container_cluster.mesh_cluster.name
}

output "workload_pool" {
  description = "Workload Identity pool configured on the cluster."
  value       = google_container_cluster.mesh_cluster.workload_identity_config[0].workload_pool
}

output "mesh_enable_command" {
  description = "Follow-up command for enabling managed service mesh through fleet tooling."
  value       = "gcloud container fleet mesh enable --project=${var.project_id}"
}
