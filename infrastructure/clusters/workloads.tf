
module "workloads" {
  source = "../../modules/gcp/gke-workload-identity/"

  for_each = { for w in var.workloads : "${w.namespace}-${var.prefix}-${w.name}" => w }

  project_id                      = var.project_id
  prefix                          = var.prefix
  name                            = each.value.name
  namespace                       = each.value.namespace
  create_namespace                = true
  automount_service_account_token = var.automount_service_account_token
  roles                           = each.value.roles
}
