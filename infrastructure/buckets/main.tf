
terraform {
  required_providers {}
}


module "dataset_bucket" {
  source = "../../modules/gcp/gcs-bucket/"

  project_id = var.project_id
  name       = "nowcast-storage-datasets"
  iam = {
    "roles/storage.admin" : "serviceAccount:${google_service_account.service_account.email}"
  }
}

module "model_bucket" {
  source = "../../modules/gcp/gcs-bucket/"

  project_id = var.project_id
  name       = "nowcast-storage-models"
  iam = {
    "roles/storage.admin" : "serviceAccount:${google_service_account.service_account.email}"
  }
}
