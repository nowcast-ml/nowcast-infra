
module "gce_persistent_disks" {
  source = "../../modules/gcp/gce-persistent-disk"

  for_each = { for disk in var.disks : "${var.prefix}-${disk.name}" => disk }

  project_id  = var.project_id
  zone        = var.zone
  name        = "${var.prefix}-${each.value.name}"
  description = each.value.desc
  size        = each.value.size
  type        = each.value.type
}
