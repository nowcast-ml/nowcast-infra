output "kubeconfig" {
  sensitive   = true
  description = "A kubeconfig file configured to access the GKE cluster."
  value       = data.template_file.kubeconfig.rendered
}

output "cluster_ca_certificate" {
  sensitive   = true
  description = "The cluster_ca_certificate value for use with the kubernetes provider."
  value       = base64decode(local.cluster_ca_certificate)
}

output "endpoint" {
  description = "The endpoint for use with the kubernetes provider."
  value       = local.endpoint
}

output "host" {
  description = "The host value for use with the kubernetes provider."
  value       = local.host
}

output "token" {
  sensitive   = true
  description = "The token value for use with the kubernetes provider."
  value       = data.google_client_config.provider.access_token
}
