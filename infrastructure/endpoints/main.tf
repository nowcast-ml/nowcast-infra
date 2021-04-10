
terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "regional_address" {
  source = "../../modules/multi/regional-address/"

  project_id         = var.project_id
  cloudflare_zone_id = var.cloudflare_zone_id

  name   = var.regional_address_name
  prefix = var.regional_address_prefix
  region = var.region

  records    = var.regional_address_records
  record_ttl = var.regional_address_record_ttl
}

