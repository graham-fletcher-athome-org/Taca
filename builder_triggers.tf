locals {
    triggers_d ={  for builder in var.builders : builder.name=> { 
            sa_name = builder.sa_name
            repo = builder.repo
            branch = builder.branch
            filename = builder.filename
            folder_ids = builder.folder_ids
    }}

    triggers = var.github_app_intilation_id!= null ? (var.bootstrap_repo != null ?
                        merge ( local.triggers_d, {
                            bootstrap = {
                                sa_name = "bootstrap"
                                repo = var.bootstrap_repo
                                branch = "main"
                                filename = "Cloudbuild.yaml"
                                folder_ids = {"root"=google_folder.top_folder.id}
                            }
                        }) : local.triggers_d):{}
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
  name = each.key
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
    _FOLDER_IDS = jsonencode({ for x,y in each.value.folder_ids : x => contains(var.content_folder_names,y) ? google_folder.content_folder[y].id : y})
    _FOUNDATION_CODE = local.foundation_code
  }

  filename = each.value.filename
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}
