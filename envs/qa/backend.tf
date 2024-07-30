terraform {
  backend "gcs" {
    bucket  = "tf-state-vikki"
    prefix  = "terraform/state"
  }
}