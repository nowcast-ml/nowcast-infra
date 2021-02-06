
terraform {
  backend "gcs" {
    bucket = "terraform-infra-cluster"
    prefix = "terraform/state/"
  }
}
