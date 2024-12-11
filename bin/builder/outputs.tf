# 1 "./builder/outputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./builder/outputs.tf" 2
output "sa" {
  value = google_service_account.builder_service_account
}

output "managed_environment" {
  value = var.managed_environment
}

output "name" {
  value = var.name
}
