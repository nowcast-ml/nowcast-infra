
locals {
  dockerconfigjson = {
    "auths" = {
      "eu.gcr.io" = {
        email    = google_service_account.service_account.email
        username = "_json_key"
        password = trimspace(base64decode(google_service_account_key.image_pull.private_key))
        auth     = base64encode(trimspace(join(":", ["_json_key", base64decode(google_service_account_key.image_pull.private_key)])))
      }
    }
  }
}

resource "google_container_registry" "registry" {
  project  = var.project_id
  location = "EU"
}

resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "gcr-${var.service_account_name}"
  display_name = "Service account for ${google_container_registry.registry.id}"
}

resource "google_service_account_key" "image_pull" {
  service_account_id = google_service_account.service_account.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_storage_bucket_iam_binding" "service_account" {
  bucket  = google_container_registry.registry.bucket_self_link
  role    = "roles/storage.admin"
  members = ["serviceAccount:${google_service_account.service_account.email}"]
}

resource "google_storage_bucket_iam_binding" "roles" {
  for_each = var.iam
  bucket   = google_container_registry.registry.id
  members  = each.value
  role     = each.key
}

data "template_file" "imagepullsecret_template" {
  template = file("${path.module}/templates/imagepullsecret.yaml.tpl")

  vars = {
    name             = var.imagepullsecret_name
    dockerconfigjson = base64encode(trimspace(jsonencode(local.dockerconfigjson)))
  }
}
