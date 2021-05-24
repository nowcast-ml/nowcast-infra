
terraform {
  required_version = "~> 0.15.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.1"
    }
  }
}
