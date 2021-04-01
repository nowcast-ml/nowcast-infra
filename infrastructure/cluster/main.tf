terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    github = {
      source = "integrations/github"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "github" {
  owner = var.fluxcd_repository_owner
  token = var.github_token
}

provider "kubectl" {
  load_config_file = false

  host                   = module.kubeconfig.endpoint
  token                  = module.kubeconfig.token
  cluster_ca_certificate = module.kubeconfig.cluster_ca_certificate

  apply_retry_count = 5
}

module "global_address" {
  source = "../../modules/multi/global-address/"

  project_id         = var.project_id
  cloudflare_zone_id = var.cloudflare_zone_id

  prefix = var.global_address_prefix

  record_names = var.global_address_record_names
  record_ttl   = var.global_address_record_ttl
}

module "cluster" {
  source = "../../modules/gcp/gke-cluster/"

  project_id = var.project_id
  name       = var.name

  zonal = true
  zones = var.zones

  release_channel    = var.kubernetes_release_channel
  kubernetes_version = var.kubernetes_version

  subnetwork_ip_cidr_range          = "10.40.0.0/16"
  subnetwork_ip_cidr_range_pods     = "10.41.0.0/16"
  subnetwork_ip_cidr_range_services = "11.42.0.0/16"

  remove_default_node_pool = true

  node_pools        = var.node_pools
  node_pools_labels = var.node_pools_labels

  enable_http_load_balancing = true
  enable_vertical_pod_autoscaling = var.cluster_vertical_pod_autoscaling

  firewall_inbound_ports = var.cluster_firewall_inbound_ports
}

module "kubeconfig" {
  source = "../../modules/gcp/gke-kubeconfig/"

  project_id   = var.project_id
  location     = module.cluster.location
  cluster_name = module.cluster.name

  depends_on = [module.cluster]
}

module "inject_manifests" {
  source = "../../modules/k8s/inject-manifest-pattern/"

  filepath_pattern = "${path.module}/../../secrets/cluster/${var.secrets_dir}/sealed-secrets-key.yaml"
}

module "fluxcd" {
  source = "../../modules/k8s/fluxcd/"

  fluxcd_version = var.fluxcd_version

  name_prefix = var.name

  repository_owner = var.fluxcd_repository_owner
  repository_name  = var.fluxcd_repository_name
  repository_path  = var.fluxcd_repository_path
}
