
output "id" {
  value = google_compute_disk.primary.id
}

output "creation_timestamp" {
  value = google_compute_disk.primary.creation_timestamp
}

output "last_attach_timestamp" {
  value = google_compute_disk.primary.last_attach_timestamp
}

output "users" {
  value = google_compute_disk.primary.users
}
