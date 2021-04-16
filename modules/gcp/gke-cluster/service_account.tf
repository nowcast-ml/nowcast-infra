
locals {
  service_account_list = compact(
    concat(
      google_service_account.cluster_service_account.*.email,
      ["dummy"],
    ),
  )
  service_account = (var.service_account == "" || var.service_account == "create") && var.create_service_account ? local.service_account_list[0] : var.service_account
}

resource "google_service_account" "cluster_service_account" {
  count        = var.create_service_account ? 1 : 0
  project      = var.project_id
  account_id   = "gke-${substr(local.cluster_name, 0, min(15, length(local.cluster_name)))}-main"
  display_name = "Service account for ${local.cluster_name}"
}

resource "google_project_iam_member" "cluster_service_account-gcr" {
  count   = var.create_service_account ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "cluster_service_account-artifact-registry" {
  count   = var.create_service_account ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}
