# 1 "./builder/make_backend.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./builder/make_backend.tf" 2
resource "local_file" "backend" {
  count      = var.make_backend ? 1 : 0
  content    = <<EOT
terraform {
  backend "gcs" {
    bucket = "${google_storage_bucket.build_assets_buckets.id}"
    prefix = "terraform/state"
  }
}
EOT
  filename   = "./backend.autogen.tf"
  depends_on = [google_storage_bucket.build_assets_buckets]
}
