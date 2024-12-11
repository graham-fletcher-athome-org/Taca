resource "local_file" "backend" {
  count      = var.make_backend ? 1 : 0
  content    = <<EOT
terraform {
  backend "gcs" {
    bucket  = "${google_storage_bucket.build_assets_buckets.id}"
    prefix  = "terraform/state"
  }
}
EOT
  filename   = "./backend.autogen.tf"
  depends_on = [google_storage_bucket.build_assets_buckets]
}