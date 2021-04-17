
locals {
  workloads = { for w in var.workloads : "${w.namespace}-${w.name}" => w }
  service_accounts_emails = { for id, _ in local.workloads: id => module.workloads[id].service_account_email }
}

module "workloads" {
  source = "../../modules/gcp/gke-workload-identity/"

  for_each = local.workloads

  project_id                      = var.project_id
  prefix                          = var.prefix
  name                            = each.value.name
  namespace                       = each.value.namespace
  automount_service_account_token = var.automount_service_account_token
  roles                           = each.value.roles
}
