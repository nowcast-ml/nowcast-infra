
terraform {
  required_version = "~> 0.14.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.53.0,<4.0.0"
    }
  }
}
