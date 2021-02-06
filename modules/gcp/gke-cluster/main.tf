
locals {
  zone_count = length(var.zones)

  location       = var.zonal ? var.zones[0] : var.region
  region         = var.zonal ? join("-", slice(split("-", var.zones[0]), 0, 2)) : var.region
  node_locations = var.zonal ? slice(var.zones, 1, local.zone_count) : coalescelist(compact(var.zones), sort(random_shuffle.available_zones.result))

  master_version_regional = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version
  master_version_zonal    = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.zone.latest_master_version
  master_version          = var.zonal ? local.master_version_zonal : local.master_version_regional

  release_channel = var.release_channel != null ? [{ channel : var.release_channel }] : []

  cluster_name                 = var.name
  cluster_network_tag          = "gke-${var.name}"
  cluster_node_metadata_config = var.node_metadata == "UNSPECIFIED" ? [] : [{ node_metadata = var.node_metadata }]
  cluster_endpoint_for_nodes   = "${google_container_cluster.primary.endpoint}/32"

  node_pool_names = [for np in toset(var.node_pools) : np.name]
  node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))

  default_auto_upgrade = var.zonal ? true : false

  workload_identity_enabled = !(var.identity_namespace == null || var.identity_namespace == "null")
  cluster_workload_identity_config = !local.workload_identity_enabled ? [] : var.identity_namespace == "enabled" ? [{
    identity_namespace = "${var.project_id}.svc.id.goog" }] : [{ identity_namespace = var.identity_namespace
  }]

  output_cluster_name     = google_container_cluster.primary.name
  output_cluster_type     = var.zonal ? "zonal" : "regional"
  output_cluster_location = google_container_cluster.primary.location
  output_cluster_region   = var.zonal ? join("-", slice(split("-", local.output_cluster_location), 0, 2)) : var.region
  output_cluster_zones    = sort(google_container_cluster.primary.node_locations)

  output_cluster_endpoint           = google_container_cluster.primary.endpoint
  output_cluster_client_certificate = base64decode(google_container_cluster.primary.master_auth.0.client_certificate)
  output_cluster_client_key         = base64decode(google_container_cluster.primary.master_auth.0.client_key)
  output_cluster_ca_certificate     = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  output_cluster_kubernetes_version = google_container_cluster.primary.min_master_version
}

data "google_compute_zones" "available" {
  provider = google

  project = var.project_id
  region  = local.region
}

data "google_container_engine_versions" "region" {
  provider = google

  location = local.location
  project  = var.project_id
}

data "google_container_engine_versions" "zone" {
  provider = google

  location = local.zone_count == 0 ? data.google_compute_zones.available.names[0] : var.zones[0]
  project  = var.project_id
}

resource "random_shuffle" "available_zones" {
  input        = data.google_compute_zones.available.names
  result_count = 3
}
