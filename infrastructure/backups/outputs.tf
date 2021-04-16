
output "bucket_name" {
  value = module.bucket.name
}

output "role_name" {
  value = google_project_iam_custom_role.role.name
}
