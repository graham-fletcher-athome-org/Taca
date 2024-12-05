/* Create service account for builder*/
resource "google_service_account" "builder_service_account" {
  account_id = var.name
  project    = var.project
}

/*Create buckets for logging and to hold state files.  Give correct permissions */
module "logbucket_names" {
  source          = "./nameing_conventions/bucket_name"
  name            = format("log-%s", var.name)
  foundation_code = var.foundation_code
}

resource "google_storage_bucket" "log_buckets" {
  name                        = module.logbucket_names.name
  location                    = coalesce(var.location_log_buckets, var.default_location)
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  project                     = var.project
  force_destroy               = true
  public_access_prevention    = "enforced"
}

resource "google_storage_bucket_iam_member" "log_bucket_iam" {
  bucket   = google_storage_bucket.log_buckets.id
  role     = "roles/storage.admin"
  member   = format("serviceAccount:%s", google_service_account.builder_service_accounts.email)
}

module "build_assets_bucket_names" {
  source          = "./nameing_conventions/bucket_name"
  name            = format("ba-%s", var.name)
  foundation_code = var.foundation_code
}

resource "google_storage_bucket" "build_assets_buckets" {
  name                        = module.build_assets_bucket_names.name
  location                    = coalesce(var.location_ba_buckets, var.default_location)
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  project                     = var.project
  force_destroy               = true
  public_access_prevention    = "enforced"
}

resource "google_storage_bucket_iam_member" "build_assets_buckets_iam" {
  bucket   = google_storage_bucket.build_assets_buckets.id
  role     = "roles/storage.objectUser"
  member   = format("serviceAccount:%s", google_service_account.builder_service_accounts.email)
}

/* Make trigger and connect to github */
resource "google_cloudbuildv2_repository" "github_repos" {
  count             = var.github_connector != null ? 1 : 0
  project           = google_project.builder_project.project_id
  location          = coalesce(var.location_build_triggers, var.default_location)
  name              = var.name
  parent_connection = var.github_connector
  remote_uri        = var.uri
}

resource "google_cloudbuild_trigger" "triggers" {
  count           = var.github_connector != null ? 1 : 0
  name            = var.name
  location        = coalesce(var.location_build_triggers, var.default_location)
  project         = google_project.builder_project.project_id
  service_account = google_service_account.builder_service_accounts.id
  ignored_files   = var.ignored_files
  included_files  = var.included_files
  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repos[0].id
    push {
      branch = each.value.branch
    }
  }
  substitutions = {
    _LOGBUCKET        = google_storage_bucket.log_buckets.id
    _BABUCKET         = google_storage_bucket.build_assets_buckets.id
    _DEFAULT_LOCATION = var.default_location
    _PLACES           = jsonencode(var.places)
    _FOUNDATION_CODE  = local.foundation_code
  }

  filename           = var.filename
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
}


