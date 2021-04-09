
variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "prefix" {
  type = string
}

variable "disks" {
  type = list(object({ name = string, desc = string, type = string, size = number }))
}
