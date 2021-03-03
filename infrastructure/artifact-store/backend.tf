
terraform {
  backend "gcs" {
    bucket = "st-nowca-terraform-artifact-store"
    prefix = "terraform/state/"
  }
}
