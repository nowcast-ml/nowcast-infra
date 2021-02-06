
module "registry" {
  source = "../../modules/gcp/gcr-registry/"

  project_id = var.project_id

  service_account_name = var.service_account_name
}

resource "local_file" "private_key" {
  sensitive_content = base64decode(module.registry.private_key)
  filename          = var.private_key_filepath
  file_permission   = 0600
}

resource "local_file" "imagepullsecret" {
  sensitive_content = module.registry.imagepullsecret
  filename          = var.imagepullsecret_filepath
  file_permission   = 0600
}
