resource "google_container_cluster" "mesh_cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location

  deletion_protection = var.deletion_protection
  initial_node_count  = var.initial_node_count
  datapath_provider   = "ADVANCED_DATAPATH"

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = var.release_channel
  }

  network    = var.network_self_link
  subnetwork = var.subnetwork_self_link
}
