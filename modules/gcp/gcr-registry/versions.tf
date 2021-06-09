
terraform {
  required_version = "~> 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.70.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}
