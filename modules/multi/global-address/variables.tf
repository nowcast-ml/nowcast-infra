
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

variable "description" {
  type    = string
  default = null
}

variable "record_names" {
  type = list(string)
}

variable "ip_versions" {
  type    = list(string)
  default = ["IPV4", "IPV6"]
}

variable "record_ttl" {
  type    = number
  default = 3600
}
