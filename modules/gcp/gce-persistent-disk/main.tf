

resource "google_compute_disk" "primary" {
  project                   = var.project_id
  name                      = "gce-${var.name}"
  description               = var.description
  labels                    = var.labels
  type                      = var.type
  size                      = var.size
  zone                      = var.zone
  physical_block_size_bytes = var.physical_block_size_bytes

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}
