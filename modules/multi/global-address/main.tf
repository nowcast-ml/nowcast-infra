
locals {
  ip_versions  = toset(var.ip_versions)
  record_names = toset(var.record_names)

  address_records_pairs = setproduct(local.record_names, local.ip_versions)

  ip_versions_map = zipmap(
    [for ip_version in local.ip_versions : ip_version],
    [for ip_version in local.ip_versions : "${var.prefix}-${lower(ip_version)}"]
  )
  records_map = zipmap(
    [for pair in local.address_records_pairs : "${var.prefix}-${pair[0]}-${lower(pair[1])}"],
    [for pair in local.address_records_pairs : { name = pair[0], ip_version = pair[1] }]
  )
}

resource "google_compute_global_address" "ips" {
  for_each = local.ip_versions_map

  project     = var.project_id
  name        = each.value
  ip_version  = each.key
  description = var.description
}

resource "cloudflare_record" "records" {
  for_each = local.records_map

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  value   = google_compute_global_address.ips[each.value.ip_version].address
  type    = each.value.ip_version == "IPV4" ? "A" : "AAAA"
  ttl     = var.record_ttl
}
