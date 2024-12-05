provider "google" {
  region      = "us-central1"
}

variable "create_new_project" {
  description = "Whether to create a new GCP project"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "The name of the GCP project"
  type        = string
  default     = "My First Project"
}

variable "project_id" {
  description = "The ID of the GCP project"
  type        = string
  default     = "exalted-kayak-429218-m7"
}

# variable "org_id" {
#   description = "The organization ID for the GCP project"
#   type        = string
# }

resource "google_project" "new_project" {
  count               = var.create_new_project ? 1 : 0
  name                = var.project_name
  project_id          = var.project_id
  #org_id              = var.org_id
  auto_create_network = true
}

resource "google_project_service" "project" {
  for_each = toset(["compute.googleapis.com", "iam.googleapis.com", "firebase.googleapis.com", "cloudbuild.googleapis.com"])
  service  = each.key
}


data "google_project" "existing_project" {
  count   = var.create_new_project ? 0 : 1
  project_id = var.project_id
}

locals {
  project_id = var.create_new_project ? google_project.new_project[0].project_id : data.google_project.existing_project[0].project_id
}

output "selected_project_id" {
  value = local.project_id
}

