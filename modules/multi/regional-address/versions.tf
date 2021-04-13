
terraform {
  required_version = "~> 0.14.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.64.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "2.19.2"
    }
  }
}
