# 1 "./managed_environment/outputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./managed_environment/outputs.tf" 2

output "places" {
  value = merge({ for key, v in google_folder.content_folder : key => { id = v.id, type = "f" } }, { parent = { id = local.parent_id, type = local.parent_type } })
}

output "git_hub_connection" {
  value = var.github_app_intigration_id != null ? google_cloudbuildv2_connection.connection[0].id : null
}

output "git_hub_enabled" {
  value = (var.github_app_intigration_id != null)
}

output "builder_project" {
  value = google_project.builder_project.project_id
}

output "default_location" {
  value = var.default_location
}

output "location_build_triggers" {
  value = var.location_build_triggers
}

output "foundation_code" {
  value = local.foundation_code
}

output "github_identity_token_secret" {
  value = google_secret_manager_secret.github_token_secret.id
}
