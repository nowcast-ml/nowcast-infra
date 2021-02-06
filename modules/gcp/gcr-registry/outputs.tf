output "bucket_id" {
  value = google_container_registry.registry.id
}

output "private_key" {
  sensitive = true
  value     = google_service_account_key.image_pull.private_key
}

output "imagepullsecret" {
  sensitive = true
  value     = data.template_file.imagepullsecret_template.rendered
}
