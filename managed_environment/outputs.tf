
output "places" {
    value = merge({for key,v in google_folder.content_folder : key => {id = v.id,type="f"}}, {parent = {id=local.parent_id,type="f"}})
}

output "git_hub_connection" {
  value = var.github_app_intigration_id != null ?  google_cloudbuildv2_connection.connection[0].id : null
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

output "pac" {
    value = data.google_secret_manager_secret_version.latest_pac.secret_data
}
