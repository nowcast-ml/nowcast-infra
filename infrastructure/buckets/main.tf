
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  service_account_name = "${var.prefix}-buckets-sa"
}

module "service_account" {
  source = "../../modules/gcp/service-account/"

  project_id    = var.project_id
  names         = [local.service_account_name]
  display_name  = "Service account for ${var.prefix}-buckets"
  generate_keys = true
}

module "buckets" {
  source = "../../modules/gcp/gcs-bucket/"

  for_each = { for bucket in var.buckets : "${var.prefix}-${bucket}" => bucket }

  project_id = var.project_id
  location   = var.zone
  name       = "${var.prefix}-${each.value}"

  iam = {
    "roles/storage.objectAdmin" = module.service_account.iam_email
  }
}
