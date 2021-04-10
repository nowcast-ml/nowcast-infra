
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  bucket_name          = "${var.name}-artifacts"
  service_account_name = "${local.bucket_name}-sa"
}

module "service_account" {
  source = "../../modules/gcp/service-account/"

  project_id    = var.project_id
  names         = [local.service_account_name]
  display_name  = "Service account for ${local.bucket_name}"
  generate_keys = true
}

module "bucket" {
  source = "../../modules/gcp/gcs-bucket/"

  project_id = var.project_id
  name       = local.bucket_name
  location   = var.location

  iam = {
    "roles/storage.objectAdmin" = module.service_account.iam_email
  }
}
