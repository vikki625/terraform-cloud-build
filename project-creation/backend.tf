terraform {
  backend "gcs" {
    bucket  = "tf-exalted-kayak-429218-m7-t54m"
    prefix  = "terraform/state"
  }
}
