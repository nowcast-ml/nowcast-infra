
terraform {
  backend "gcs" {
    bucket = "st-nowca-terraform-buckets"
    prefix = "terraform/state/"
  }
}
