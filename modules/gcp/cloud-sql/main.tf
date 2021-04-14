
locals {
  instance_name = "${var.prefix}-${var.instance_name}"
  database_name = "${var.prefix}-${var.database_name}"
}

resource "google_sql_database_instance" "primary" {
  project = var.project_id

  name   = local.instance_name
  region = var.region

  database_version = var.database_version

  settings {
    tier = var.instance_tier

    availability_type = var.instance_availability_type

    disk_type = var.instance_disk_type
    disk_size = var.instance_disk_size

    location_preference {
      zone = var.zone
    }
  }
}

resource "google_sql_database" "primary" {
  count = var.enable_primary_database ? 1 : 0

  project   = var.project_id
  name      = local.database_name
  instance  = google_sql_database_instance.primary.name
  charset   = var.database_charset
  collation = var.database_collation

  depends_on = [google_sql_database_instance.primary]
}

resource "google_sql_user" "primary" {
  count = var.enable_primary_user ? 1 : 0

  project  = var.project_id
  name     = var.username
  instance = google_sql_database_instance.primary.name
  password = var.password == "" ? random_id.password.hex : var.password

  depends_on = [google_sql_database_instance.primary]
}

resource "random_id" "password" {
  keepers = {
    name = google_sql_database_instance.primary.name
  }

  byte_length = 8
  depends_on  = [google_sql_database_instance.primary]
}
