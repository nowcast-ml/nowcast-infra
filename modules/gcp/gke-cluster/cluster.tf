
resource "google_container_cluster" "primary" {
  provider = google

  name            = local.cluster_name
  description     = var.description
  project         = var.project_id
  resource_labels = var.resource_labels
  location        = local.location
  node_locations  = local.node_locations

  dynamic "release_channel" {
    for_each = local.release_channel
    content {
      channel = release_channel.value.channel
    }
  }

  min_master_version = var.release_channel != null ? null : local.master_version

  network    = google_compute_network.vpc_network.self_link
  subnetwork = google_compute_subnetwork.vpc_subnetwork.self_link

  network_policy {
    enabled  = var.enable_network_policy
    provider = var.enable_network_policy ? "CALICO" : "PROVIDER_UNSPECIFIED"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-1"
    services_secondary_range_name = "gke-services-1"
  }

  master_auth {
    username = var.basic_auth_username
    password = var.basic_auth_password

    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  dynamic "database_encryption" {
    for_each = var.database_encryption

    content {
      key_name = database_encryption.value.key_name
      state    = database_encryption.value.state
    }
  }

  enable_shielded_nodes = var.enable_shielded_nodes

  addons_config {
    http_load_balancing {
      disabled = !var.enable_http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.enable_horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = !var.enable_network_policy
    }

  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  dynamic "workload_identity_config" {
    for_each = local.cluster_workload_identity_config

    content {
      identity_namespace = workload_identity_config.value.identity_namespace
    }
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    node_config {
      service_account = lookup(var.node_pools[0], "service_account", local.service_account)

      oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]

      dynamic "workload_metadata_config" {
        for_each = local.cluster_node_metadata_config

        content {
          node_metadata = workload_metadata_config.value.node_metadata
        }
      }
    }
  }

  remove_default_node_pool = var.remove_default_node_pool

  logging_service    = "none"
  monitoring_service = "none"

  lifecycle {
    ignore_changes = [
      initial_node_count,
      node_pool
    ]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  depends_on = [
    google_compute_network.vpc_network,
    google_compute_subnetwork.vpc_subnetwork
  ]
}
