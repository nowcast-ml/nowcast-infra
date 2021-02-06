terraform {
  backend "gcs" {
    bucket = "terraform-infra-backup"
    prefix = "terraform/state/"
  }
}
