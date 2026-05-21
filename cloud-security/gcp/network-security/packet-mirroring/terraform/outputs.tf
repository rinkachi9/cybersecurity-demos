output "packet_mirroring_policy_id" {
  description = "Packet mirroring policy ID."
  value       = google_compute_packet_mirroring.security_mirror_policy.id
}

output "collector_forwarding_rule" {
  description = "Internal collector forwarding rule ID."
  value       = google_compute_forwarding_rule.mirror_collector_ilb.id
}
