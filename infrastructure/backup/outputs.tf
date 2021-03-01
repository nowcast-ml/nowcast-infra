
output "service_account" {
  value = module.backup_account.service_account.name
}

output "key" {
  sensitive = true
  value     = module.backup_account.key
}
