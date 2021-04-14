
output "public_ipv4" {
  value = google_sql_database_instance.primary.public_ip_address
}

output "private_ipv4" {
  value = google_sql_database_instance.primary.private_ip_address
}

output "instance_ipv4" {
  value = google_sql_database_instance.primary.ip_address
}
