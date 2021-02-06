output "access_key" {
  value = google_storage_hmac_key.key.access_id
}

output "secret_key" {
  value     = google_storage_hmac_key.key.secret
  sensitive = true
}
