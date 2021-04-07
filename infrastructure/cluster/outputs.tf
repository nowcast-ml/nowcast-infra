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

output "ipv4" {
  value = module.global_address.addresses["IPV4"].address
}

output "ipv6" {
  value = module.global_address.addresses["IPV6"].address
}

output "records" {
  sensitive = true
  value     = module.global_address.records
}
