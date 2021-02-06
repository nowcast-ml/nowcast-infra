
terraform {
  required_version = "~> 0.14.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.9.4"
    }
  }
}
