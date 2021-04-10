
variable "project_id" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "name" {
  type = string
}

variable "github_token" {
  sensitive = true
  type      = string
}

variable "zones" {
  type = list(string)
}

variable "node_pools" {
  type = list(map(string))
}

variable "node_pools_taints" {
  type = map(list(object({ key = string, value = string, effect = string })))
}

variable "node_pools_labels" {
  type = map(map(string))
}

variable "fluxcd_version" {
  type = string
}

variable "kubernetes_release_channel" {
  type    = string
  default = null
}

variable "kubernetes_version" {
  type = string
}

variable "cluster_enable_http_load_balancing" {
  type = bool
}

variable "cluster_vertical_pod_autoscaling" {
  type = bool
}

variable "cluster_firewall_inbound_ports" {
  type = list(string)
}

variable "fluxcd_repository_owner" {
  type = string
}

variable "fluxcd_repository_name" {
  type = string
}

variable "fluxcd_repository_path" {
  type = string
}

variable "secrets_dir" {
  type = string
}
