terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}
 
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
}
 
resource "google_sql_database_instance" "postgres_instance" {
  name             = "pg-instance-pe"
  region           = var.region
  database_version = "POSTGRES_14"
  deletion_protection = false
 
  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all"
        value = "0.0.0.0/0"
      }
    }
  }
}
 
resource "google_sql_database" "empresa_db" {
  name     = "empresa"
  instance = google_sql_database_instance.postgres_instance.name
}
 
resource "google_sql_user" "pg_user" {
  name     = "devuser"
  instance = google_sql_database_instance.postgres_instance.name
  password = "devpass"
}
 
output "connection_name" {
  value = google_sql_database_instance.postgres_instance.connection_name
}
