output "ids_endpoint_name" {
  description = "Cloud IDS endpoint name."
  value       = google_cloud_ids_endpoint.ids_endpoint.name
}

output "ids_endpoint_id" {
  description = "Cloud IDS endpoint ID."
  value       = google_cloud_ids_endpoint.ids_endpoint.id
}

output "ids_endpoint_location" {
  description = "Cloud IDS endpoint location."
  value       = google_cloud_ids_endpoint.ids_endpoint.location
}

output "ids_endpoint_forwarding_rule" {
  description = "Forwarding rule used as the packet mirroring collector."
  value       = google_cloud_ids_endpoint.ids_endpoint.endpoint_forwarding_rule
}

output "packet_mirroring_policy_name" {
  description = "Packet mirroring policy name when enabled."
  value       = try(google_compute_packet_mirroring.mirror_to_ids[0].name, null)
}

output "network_self_link" {
  description = "VPC network monitored by Cloud IDS."
  value       = local.network_self_link
}

output "reserved_peering_ranges" {
  description = "Reserved private service ranges used by Service Networking."
  value       = local.reserved_peering_ranges
}

output "minimum_threat_severity" {
  description = "Minimum threat severity configured for the IDS endpoint."
  value       = var.minimum_threat_severity
}
