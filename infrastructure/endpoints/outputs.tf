
output "ipv4" {
  value = module.regional_address.ipv4
}


output "records" {
  sensitive = true
  value     = module.regional_address.records
}
