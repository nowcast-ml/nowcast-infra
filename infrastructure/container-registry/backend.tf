terraform {
  backend "gcs" {
    bucket = "terraform-infra-container-registry"
    prefix = "terraform/state/"
  }
}
