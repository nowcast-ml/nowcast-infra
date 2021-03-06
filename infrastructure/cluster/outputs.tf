output "name" {
  value = module.cluster.name
}

output "endpoint" {
  sensitive = true
  value     = module.kubeconfig.endpoint
}

output "kubeconfig" {
  sensitive = true
  value     = module.kubeconfig.kubeconfig
}

output "addresses" {
  value = module.global_address.addresses
}

output "records" {
  sensitive = true
  value     = module.global_address.records
}
