
output "service_account_email" {
  sensitive = true
  value = google_service_account.gcp_service_account.email
}
