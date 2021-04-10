
output "ipv4" {
  value = google_compute_address.ip.address
}

output "records" {
  sensitive = true
  value     = cloudflare_record.records
}
