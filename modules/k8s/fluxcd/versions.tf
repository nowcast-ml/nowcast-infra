
terraform {
  required_version = "~> 0.14.0"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "0.0.12"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.10.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.0.0"
    }
  }
}
