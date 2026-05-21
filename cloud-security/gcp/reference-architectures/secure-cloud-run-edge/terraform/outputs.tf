output "load_balancer_ip" {
  description = "Global load balancer IP address."
  value       = google_compute_global_address.edge.address
}

output "cloud_run_service_name" {
  description = "Cloud Run service name."
  value       = google_cloud_run_v2_service.app.name
}

output "cloud_run_uri" {
  description = "Default Cloud Run URI. Direct access should be blocked by ingress."
  value       = google_cloud_run_v2_service.app.uri
}

output "backend_service_name" {
  description = "Backend service protected by IAP and Cloud Armor."
  value       = google_compute_backend_service.edge.name
}

output "cloud_armor_policy_name" {
  description = "Cloud Armor policy attached to the backend service."
  value       = google_compute_security_policy.edge.name
}

output "iap_members" {
  description = "Members granted IAP HTTPS access."
  value       = sort(tolist(var.iap_members))
}

