locals {
  name        = "${var.name_prefix}-${var.namespace}"
  known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
}

data "flux_install" "install" {
  target_path          = var.repository_path
  namespace            = var.namespace
  version              = var.fluxcd_version
  watch_all_namespaces = true
}

data "flux_sync" "sync" {
  url         = "ssh://git@github.com/${var.repository_owner}/${var.repository_name}.git"
  branch      = var.repository_branch
  target_path = var.repository_path
  name        = var.namespace
  namespace   = var.namespace
}

data "kubectl_file_documents" "manifests_install" {
  content = data.flux_install.install.content
}

data "kubectl_file_documents" "manifests_sync" {
  content = data.flux_sync.sync.content
}

resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "kubectl_manifest" "namespace" {
  yaml_body = <<YAML
    apiVersion: v1
    kind: Namespace
    apiVersion: v1
    metadata:
      name: ${var.namespace}
      labels:
        name: ${var.namespace}
  YAML
}

resource "kubectl_manifest" "fluxcd_install" {
  for_each  = { for v in data.kubectl_file_documents.manifests_install.documents : sha1(v) => v }
  yaml_body = each.value

  depends_on = [kubectl_manifest.namespace]
}

resource "kubectl_manifest" "fluxcd_sync" {
  for_each  = { for v in data.kubectl_file_documents.manifests_sync.documents : sha1(v) => v }
  yaml_body = each.value

  depends_on = [kubectl_manifest.fluxcd_install]
}

resource "kubectl_manifest" "secret" {
  yaml_body = <<YAML
    apiVersion: v1
    kind: Secret
    metadata:
      name: ${data.flux_sync.sync.name}
      namespace: ${data.flux_sync.sync.namespace}
      labels:
        name: ${data.flux_sync.sync.namespace}
    data:
      identity: |
        ${base64encode(tls_private_key.deploy_key.private_key_pem)}
      identity.pub: |
        ${base64encode(tls_private_key.deploy_key.public_key_pem)}
      known_hosts: |
        ${base64encode(local.known_hosts)}
  YAML

  depends_on = [
    github_repository_deploy_key.main,
    kubectl_manifest.namespace,
    kubectl_manifest.fluxcd_install
  ]
}

resource "github_repository_deploy_key" "main" {
  repository = var.repository_name
  title      = local.name
  key        = tls_private_key.deploy_key.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  count = var.manage_manifests ? 1 : 0

  repository = var.repository_name
  file       = data.flux_install.install.path
  content    = data.flux_install.install.content
  branch     = var.repository_branch
}

resource "github_repository_file" "sync" {
  count = var.manage_manifests ? 1 : 0

  repository = var.repository_name
  file       = data.flux_sync.sync.path
  content    = data.flux_sync.sync.content
  branch     = var.repository_branch
}

resource "github_repository_file" "kustomize" {
  count = var.manage_manifests ? 1 : 0

  repository = var.repository_name
  file       = data.flux_sync.sync.kustomize_path
  content    = data.flux_sync.sync.kustomize_content
  branch     = var.repository_branch
}
