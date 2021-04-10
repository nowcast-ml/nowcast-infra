variable "project_id" {
  type = string
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_zone_id" {
  type = string
}

variable "region" {
  type = string
}

variable "regional_address_name" {
  type = string
}

variable "regional_address_prefix" {
  type = string
}

variable "regional_address_records" {
  type = list(string)
}

variable "regional_address_record_ttl" {
  type = number
}

