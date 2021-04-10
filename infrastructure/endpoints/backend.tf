
terraform {
  backend "gcs" {
    bucket = "st-nowca-terraform-infra"
    prefix = "terraform/state/endpoints/"
  }
}
