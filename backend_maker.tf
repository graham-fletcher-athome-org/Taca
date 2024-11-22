resource "local_file" "backend" {
  count    = var.bootstrap_repo != null && var.github_app_intigration_id != null ? 1 : 0
  content  = <<EOT
terraform {
  backend "gcs" {
    bucket  = "${google_storage_bucket.build_assets_buckets["bootstrap"].id}"
    prefix  = "terraform/state"
  }
}
EOT
  filename = "./backend.tf"
}