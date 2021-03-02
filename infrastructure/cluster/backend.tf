
terraform {
  backend "gcs" {
    bucket = "st-nowca-terraform-cluster"
    prefix = "terraform/state/"
  }
}
