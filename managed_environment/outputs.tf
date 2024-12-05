output "places" {
    value = merge ({key,v in google_folder.content_folder : key => v.id}, {parent = local.parent_id})
}

output "git_hub_connection" {
  value = var.github_app_intigration_id != null ?  google_cloudbuildv2_connection.connection.id : null
}

output "builder_project" {
  value = google_project.builder_project.project_id
}