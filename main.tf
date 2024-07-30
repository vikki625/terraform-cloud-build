resource "google_cloudfunctions2_function" "hello" {
  description  = null
  kms_key_name = null
  labels       = {}
  location     = var.location
  name         = var.function_name
  project      = var.project_number
  build_config {
    docker_repository     = "projects/exalted-kayak-429218-m7/locations/us-central1/repositories/gcf-artifacts"
    entry_point           = "helloHttp"
    environment_variables = {}
    runtime               = "nodejs20"
    service_account       = "projects/exalted-kayak-429218-m7/serviceAccounts/865839242171-compute@developer.gserviceaccount.com"
    worker_pool           = null
    automatic_update_policy {
    }
    source {
      storage_source {
        bucket     = "gcf-v2-sources-865839242171-us-central1"
        generation = 1722174123722593
        object     = "function-1/function-source.zip"
      }
    }
  }
  service_config {
    all_traffic_on_latest_revision = true
    available_cpu                  = "1"
    available_memory               = "256Mi"
    environment_variables = {
      LOG_EXECUTION_ID = "true"
    }
    ingress_settings                 = "ALLOW_ALL"
    max_instance_count               = 100
    max_instance_request_concurrency = 2
    min_instance_count               = 0
    service                          = "projects/exalted-kayak-429218-m7/locations/us-central1/services/function-1"
    service_account_email            = "865839242171-compute@developer.gserviceaccount.com"
    timeout_seconds                  = 60
    vpc_connector                    = null
    vpc_connector_egress_settings    = null
  }
}
