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

output "workload_identity_service_accounts" {
  sensitive = true
  value = local.service_accounts_emails
}
