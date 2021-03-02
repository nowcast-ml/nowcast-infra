
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  bucket_name          = "${var.name}-backup"
  service_account_name = "${local.bucket_name}-sa"
  role_name            = replace("${local.bucket_name}-role", "-", "_")
}

resource "google_project_iam_custom_role" "backup_role" {
  project = var.project_id

  role_id = local.role_name
  title   = "Role for ${local.service_account_name}"
  permissions = [
    "compute.disks.get",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.snapshots.get",
    "compute.snapshots.create",
    "compute.snapshots.useReadOnly",
    "compute.snapshots.delete",
    "compute.zones.get"
  ]
}

resource "google_project_iam_binding" "backup_iam_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.backup_role.id

  members = [
    module.service_account.iam_email,
  ]
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
