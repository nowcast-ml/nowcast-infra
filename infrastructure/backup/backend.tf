
terraform {
  backend "gcs" {
    bucket = "st-nowca-terraform-backup"
    prefix = "terraform/state/"
  }
}
