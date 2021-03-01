
output "addresses" {
  value = google_compute_global_address.ips
}

output "records" {
  sensitive = true
  value     = cloudflare_record.records
}
