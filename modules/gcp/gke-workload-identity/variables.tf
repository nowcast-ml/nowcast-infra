variable "project_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "automount_service_account_token" {
  description = "Enable automatic mounting of the service account token"
  default     = false
  type        = bool
}

variable "roles" {
  type    = list(string)
  default = []
}
