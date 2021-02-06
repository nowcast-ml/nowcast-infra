
resource "google_compute_network" "vpc_network" {
  provider = google

  name    = "${local.cluster_network_tag}-vpc-network"
  project = var.project_id

  auto_create_subnetworks = "false"
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  provider = google

  name    = "${local.cluster_network_tag}-vpc-subnetwork"
  region  = local.region
  project = var.project_id
  network = google_compute_network.vpc_network.self_link

  private_ip_google_access = true

  ip_cidr_range = var.subnetwork_ip_cidr_range

  secondary_ip_range {
    range_name    = "gke-pods-1"
    ip_cidr_range = var.subnetwork_ip_cidr_range_pods
  }

  secondary_ip_range {
    range_name    = "gke-services-1"
    ip_cidr_range = var.subnetwork_ip_cidr_range_services
  }

  lifecycle {
    ignore_changes = [secondary_ip_range]
  }
}
