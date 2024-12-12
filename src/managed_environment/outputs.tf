#include "./place.h"

output "places" {
  value = flatten([[ for key, v in google_folder.content_folder : place_new(key, v.id, "f") ], [place_new("parent", local.parent_id, local.parent_type) ]])
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
