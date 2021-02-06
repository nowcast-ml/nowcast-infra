variable "name_prefix" {
  type        = string
  description = ""
}

variable "repository_owner" {
  type        = string
  description = ""
}

variable "repository_name" {
  type        = string
  description = ""
}

variable "repository_branch" {
  type        = string
  description = ""
  default     = "main"
}

variable "repository_path" {
  type        = string
  description = ""
}

variable "namespace" {
  type        = string
  description = ""
  default     = "flux-system"
}

variable "fluxcd_version" {
  type        = string
  description = ""
  default     = "latest"
}

variable "manage_manifests" {
  type    = bool
  default = true
}
