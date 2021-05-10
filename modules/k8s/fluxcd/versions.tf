
terraform {
  required_version = "~> 0.15.0"
  required_providers {
    flux = {
      source  = "fluxcd/flux"
      version = "0.1.5"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.10.0"
    }
    github = {
      source  = "integrations/github"
      version = "4.9.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
}
