
data "kubectl_filename_list" "manifests" {
  pattern = var.filepath_pattern
}

resource "kubectl_manifest" "inject" {
  count            = length(data.kubectl_filename_list.manifests.matches)
  yaml_body        = file(element(data.kubectl_filename_list.manifests.matches, count.index))
  force_new        = var.force_recreate
  sensitive_fields = ["data"]
}
