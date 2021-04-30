
terraform {
  required_version = "~> 0.15.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.66.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
