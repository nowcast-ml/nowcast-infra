
terraform {
  backend "gcs" {
    bucket = "terraform-infra-buckets"
    prefix = "terraform/state/"
  }
}
