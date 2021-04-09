
variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "labels" {
  type    = map(string)
  default = {}
}

variable "type" {
  type = string
}

variable "size" {
  type = number
}

variable "zone" {
  type = string
}

variable "physical_block_size_bytes" {
  type    = number
  default = 4096
}
