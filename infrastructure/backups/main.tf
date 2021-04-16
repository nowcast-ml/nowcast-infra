
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

locals {
  bucket_name = "${var.prefix}-${var.name}"
  role_name   = replace(local.bucket_name, "-", "_")
}

resource "google_project_iam_custom_role" "role" {
  project = var.project_id

  role_id = local.role_name
  title   = "Role for velero backups"
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

module "bucket" {
  source = "../../modules/gcp/gcs-bucket/"

  project_id = var.project_id
  name       = local.bucket_name
  location   = var.zone
}
