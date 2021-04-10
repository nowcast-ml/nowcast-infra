
variable "project_id" {
  type = string
}

variable "cloudflare_zone_id" {
  sensitive = true
  type      = string
}

variable "prefix" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "region" {
  type = string
}

variable "records" {
  type = list(string)
}

variable "record_ttl" {
  type    = number
  default = 3600
}
