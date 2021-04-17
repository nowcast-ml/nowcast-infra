
locals {
  name    = "${var.prefix}-${var.name}"
  sa_name = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${var.name}]"
}

resource "google_service_account" "gcp_service_account" {
  project      = var.project_id
  account_id   = substr(local.name, 0, 30)
  display_name = substr("GCP sa bound to k8s sa ${var.namespace}/${var.name}", 0, 100)
}

# resource "kubernetes_service_account" "k8s_service_account" {
#   automount_service_account_token = var.automount_service_account_token

#   metadata {
#     name      = var.name
#     namespace = var.namespace
#     annotations = {
#       "iam.gke.io/gcp-service-account" = google_service_account.gcp_service_account.email
#     }
#   }
# }

resource "google_service_account_iam_member" "membership" {
  service_account_id = google_service_account.gcp_service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.sa_name

  depends_on = [
    # kubernetes_service_account.k8s_service_account,
    google_service_account.gcp_service_account
  ]
}

resource "google_project_iam_member" "bingings" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gcp_service_account.email}"
}
