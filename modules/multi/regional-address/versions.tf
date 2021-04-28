
terraform {
  required_version = "~> 0.15.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.65.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.20.0"
    }
  }
}
