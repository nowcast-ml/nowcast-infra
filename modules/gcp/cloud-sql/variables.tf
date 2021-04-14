
variable "project_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_tier" {
  type = string
}

variable "instance_availability_type" {
  type    = string
  default = "ZONAL"
}

variable "instance_disk_type" {
  type    = string
  default = "PD_HDD"
}

variable "instance_disk_size" {
  type    = number
  default = 10
}

variable "database_version" {
  type = string
}

variable "database_name" {
  type = string
}

variable "database_charset" {
  type = string
}

variable "database_collation" {
  type = string
}

variable "enable_primary_database" {
  type    = bool
  default = false
}

variable "enable_primary_user" {
  type    = bool
  default = false
}

variable "username" {
  type = string
}

variable "password" {
  type = string
  default = ""
}
