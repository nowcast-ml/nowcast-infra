variable "project_id" {
  type = string
}

variable "names" {
  type    = list(string)
  default = []
}

variable "prefix" {
  type    = string
  default = ""
}

variable "roles" {
  type    = list(string)
  default = []
}

variable "display_name" {
  type    = string
  default = "Terraform-managed service account"
}

variable "description" {
  type    = string
  default = ""
}

variable "generate_keys" {
  type    = bool
  default = false
}
