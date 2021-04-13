locals {
  name        = "${var.name_prefix}-${var.namespace}"
  known_hosts = "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="

  install = [for v in data.kubectl_file_documents.manifests_install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [for v in data.kubectl_file_documents.manifests_sync.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
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

resource "kubernetes_namespace" "flux_namespace" {
  metadata {
    name = var.namespace
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubectl_manifest" "fluxcd_install" {
  for_each  = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  yaml_body = each.value

  depends_on = [kubernetes_namespace.flux_namespace]
}

resource "kubectl_manifest" "fluxcd_sync" {
  for_each  = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  yaml_body = each.value

  depends_on = [kubernetes_namespace.flux_namespace, kubectl_manifest.fluxcd_install]
}

resource "kubernetes_secret" "main" {
  metadata {
    name      = data.flux_sync.sync.secret
    namespace = data.flux_sync.sync.namespace
  }

  data = {
    identity       = tls_private_key.deploy_key.private_key_pem
    "identity.pub" = tls_private_key.deploy_key.public_key_pem
    known_hosts    = local.known_hosts
  }

  depends_on = [kubectl_manifest.fluxcd_install]
}

resource "github_repository_deploy_key" "main" {
  repository = var.repository_name
  title      = local.name
  key        = tls_private_key.deploy_key.public_key_openssh
  read_only  = true
}

resource "github_repository_file" "install" {
  count = var.manage_manifests ? 1 : 0

  repository          = var.repository_name
  file                = data.flux_install.install.path
  content             = data.flux_install.install.content
  branch              = var.repository_branch
  overwrite_on_create = true
}

resource "github_repository_file" "sync" {
  count = var.manage_manifests ? 1 : 0

  repository          = var.repository_name
  file                = data.flux_sync.sync.path
  content             = data.flux_sync.sync.content
  branch              = var.repository_branch
  overwrite_on_create = true
}

resource "github_repository_file" "kustomize" {
  count = var.manage_manifests ? 1 : 0

  repository          = var.repository_name
  file                = data.flux_sync.sync.kustomize_path
  content             = data.flux_sync.sync.kustomize_content
  branch              = var.repository_branch
  overwrite_on_create = true
}
