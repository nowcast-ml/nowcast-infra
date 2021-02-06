variable "project_id" {
  type      = string
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

variable "node_pools_labels" {
  type = map(map(string))
}

variable "fluxcd_version" {
  type = string
}

variable "kubernetes_release_channel" {
  type = string
}

variable "kubernetes_version" {
  type = string
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
