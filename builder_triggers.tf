locals {
    triggers =var.github_app_intilation_id!= null  ? {  for builder in var.builders : builder.name=> { 
            sa_name = builder.sa_name
            repo = builder.repo
            branch = builder.branch
    }} : {}
}
output "joe" {
    value = local.triggers
}

resource "google_cloudbuildv2_repository" "github_repos" {
    for_each = local.triggers
    project = google_project.builder_project.project_id
    location = coalesce(var.location_build_triggers,var.default_location)
    name = each.key
    parent_connection = try(local.git_hub_connection_id,"no connection")
    remote_uri = each.value.repo

    depends_on = [google_project_service.cloud_build_service]
  }

resource "google_cloudbuild_trigger" "triggers" {
  for_each = local.triggers
  location = coalesce(var.location_build_triggers,var.default_location)
  project = google_project.builder_project.project_id
  service_account = google_service_account.builder_service_accounts[each.value.sa_name].id
  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repos[each.key].id
    push {
      branch = each.value.branch
    }
  }
  substitutions = {
    _LOGBUCKET = google_storage_bucket.log_buckets[each.key].id
    _BABUCKET = google_storage_bucket.build_assets_buckets[each.key].id
    _DEFAULT_LOCATION = var.default_location
  }

  filename = "cloudbuild.yaml"
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}
