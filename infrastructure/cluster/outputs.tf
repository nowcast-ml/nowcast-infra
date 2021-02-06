output "name" {
  value = module.cluster.name
}

output "cluster_endpoint" {
  value = module.kubeconfig.endpoint
}

output "kubeconfig" {
  sensitive = true
  value     = module.kubeconfig.kubeconfig
}
