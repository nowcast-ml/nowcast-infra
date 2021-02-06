
resource "google_storage_bucket" "bucket" {
  name     = var.name
  project  = var.project_id
  location = var.location

  storage_class               = var.storage_class
  force_destroy               = var.force_destroy
  uniform_bucket_level_access = var.enable_uniform_bucket_level_access

  versioning {
    enabled = var.enable_versioning
  }
}

resource "google_storage_bucket_iam_member" "roles" {
  for_each = var.iam

  bucket = google_storage_bucket.bucket.name
  role   = each.key
  member = each.value
}
