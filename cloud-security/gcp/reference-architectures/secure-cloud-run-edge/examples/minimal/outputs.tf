output "load_balancer_ip" {
  value = module.secure_cloud_run_edge.load_balancer_ip
}

output "cloud_run_uri" {
  value = module.secure_cloud_run_edge.cloud_run_uri
}

output "backend_service_name" {
  value = module.secure_cloud_run_edge.backend_service_name
}

output "cloud_armor_policy_name" {
  value = module.secure_cloud_run_edge.cloud_armor_policy_name
}

