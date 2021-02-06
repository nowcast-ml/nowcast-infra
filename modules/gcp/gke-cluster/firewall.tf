
resource "google_compute_firewall" "master_webhooks" {
  name        = "gke-${substr(var.name, 0, min(25, length(var.name)))}-webhooks"
  description = "GKE admission controller webhooks"
  project     = var.project_id
  network     = google_compute_network.vpc_network.self_link
  priority    = var.firewall_priority
  direction   = "INGRESS"

  source_ranges = [local.cluster_endpoint_for_nodes]
  target_tags   = [local.cluster_network_tag]

  allow {
    protocol = "tcp"
    ports    = var.firewall_inbound_ports
  }

  depends_on = [
    google_container_cluster.primary,
  ]
}
