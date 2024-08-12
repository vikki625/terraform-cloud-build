provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {
  description = "The ID of the project in which to create the trigger."
  type        = string
  default     = ""
}

variable "region" {
  description = "The region in which to create the trigger."
  type        = string
  default     = "us-central1"
}

data "local_file" "env" {
  filename = "${path.module}/../code/.env"
}

locals {
  function_bucket_name = "gcs-dynamic-deployment-gcf"
  function_name        = "node-function"
  env_vars = { for line in split("\n", data.local_file.env.content) : split("=", line)[0] => split("=", line)[1] }
}

# source code zip file to send to the cloud function
data "archive_file" "source_zip" {
  type        = "zip"
  source_dir  = "${path.root}/../code/"
  output_path = "${path.root}/../code/function.zip"
}

# storage bucket for our code/zip file
resource "google_storage_bucket" "function_bucket" {
  project                     = ""
  name                        = local.function_bucket_name
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = true
  versioning {
    enabled = true
  }
}

# upload zipped code to the bucket
resource "google_storage_bucket_object" "function" {
  name   = format("%s-%s.zip", local.function_name, data.archive_file.source_zip.output_md5)
  bucket = google_storage_bucket.function_bucket.name
  source = "${path.root}/../code/function.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = local.function_name
  description = "My function"
  runtime     = "nodejs18"

  available_memory_mb          = 128
  source_archive_bucket        = google_storage_bucket.function_bucket.name
  source_archive_object        = google_storage_bucket_object.function.name
  trigger_http                 = true
  https_trigger_security_level = "SECURE_ALWAYS"
  timeout                      = 60
  entry_point                  = "helloHttp"
  service_account_email        = "865839242171-compute@developer.gserviceaccount.com"
  labels = {
    my-label = "dev"
  }
  environment_variables = local.env_vars
}