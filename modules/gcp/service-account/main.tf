locals {
  prefix                = var.prefix != "" ? "${var.prefix}-" : ""
  names                 = toset(var.names)
  roles                 = toset(var.roles)
  service_accounts_list = [for name in var.names : google_service_account.service_accounts[name]]
  emails_list           = [for account in local.service_accounts_list : account.email]
  iam_emails_list       = [for email in local.emails_list : "serviceAccount:${email}"]
  keys_list             = [for name in var.names : google_service_account_key.keys[name]]

  name_role_pairs = setproduct(local.names, local.roles)
  iams = zipmap(
    [for pair in local.name_role_pairs : "${pair[0]}-${pair[1]}"],
    [for pair in local.name_role_pairs : { name = pair[0], role = pair[1] }]
  )
}

resource "google_service_account" "service_accounts" {
  for_each = local.names

  project      = var.project_id
  account_id   = "${local.prefix}${lower(each.value)}"
  display_name = var.display_name
  description  = var.description
}

resource "google_project_iam_member" "project-roles" {
  for_each = local.iams

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.service_accounts[each.value.name].email}"
}

resource "google_service_account_key" "keys" {
  for_each = var.generate_keys ? local.names : toset([])

  service_account_id = google_service_account.service_accounts[each.value].email
}
