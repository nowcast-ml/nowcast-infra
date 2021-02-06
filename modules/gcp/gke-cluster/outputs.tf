
output "name" {
  description = "Cluster name"
  value       = local.output_cluster_name
}

output "type" {
  description = "Cluster type (regional/zonal)"
  value       = local.output_cluster_type
}

output "region" {
  description = "Cluster region"
  value       = local.output_cluster_region
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = local.output_cluster_zones
}

output "client_certificate" {
  description = "Client certificate"
  value       = local.output_cluster_client_certificate
  sensitive   = true

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.node_pools
  ]
}

output "client_key" {
  description = "Client key"
  value       = local.output_cluster_client_key
  sensitive   = true

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.node_pools
  ]
}

output "cluster_ca_certificate" {
  description = "Cluster CA certificate"
  value       = local.output_cluster_ca_certificate
  sensitive   = true

  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.node_pools
  ]
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = local.output_cluster_endpoint
  sensitive   = true


  depends_on = [
    google_container_cluster.primary,
    google_container_node_pool.node_pools
  ]
}

output "kubernetes_version" {
  description = "Master kubernetes version"
  value       = local.output_cluster_kubernetes_version
}

output "location" {
  description = ""
  value       = local.location
}

output "service_account" {
  value     = google_service_account.cluster_service_account[0]
}
