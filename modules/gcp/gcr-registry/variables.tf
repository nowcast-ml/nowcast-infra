
variable "project_id" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "iam" {
  type    = map(list(string))
  default = {}
}

variable "imagepullsecret_name" {
  type    = string
  default = "gcr-auth"
}
