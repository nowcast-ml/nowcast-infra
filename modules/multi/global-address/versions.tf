
terraform {
  required_version = "~> 0.14.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.53.0,<4.0.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">=2.18.0,<3.0.0"
    }
  }
}
