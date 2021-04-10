
locals {
  name    = "${var.prefix}-${var.name}"
  records = toset(var.records)
}

resource "google_compute_address" "ip" {
  project     = var.project_id
  name        = local.name
  region      = var.region
  description = var.description
}

resource "cloudflare_record" "records" {
  for_each = local.records

  zone_id = var.cloudflare_zone_id
  name    = each.value
  value   = google_compute_address.ip.address
  type    = "A"
  ttl     = var.record_ttl
}
