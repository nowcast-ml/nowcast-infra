
output "service_account" {
  value = module.service_account.service_account.name
}

output "key" {
  sensitive = true
  value     = module.service_account.key
}
