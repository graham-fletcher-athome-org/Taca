output "sa" {
  value = google_service_account.builder_service_account
}

output "managed_environment" {
  value = var.managed_environment
}

output "name" {
  value = var.name
}