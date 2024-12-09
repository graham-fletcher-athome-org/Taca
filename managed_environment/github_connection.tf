resource "google_secret_manager_secret" "github_token_secret" {

  project   = google_project.builder_project.project_id
  secret_id = "github"

  replication {
    auto {}
  }
  depends_on = [google_project_service.sm_service]
}
/*
resource "google_secret_manager_secret_version" "github_token_secret_version" {
  secret      = google_secret_manager_secret.github_token_secret.id
  secret_data = var.pac
  lifecycle {
    ignore_changes = [secret_data,]
  }
}
*/

data "google_iam_policy" "serviceagent_secretAccessor" {
  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = [format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", google_project.builder_project.number)]
  }
}
resource "google_secret_manager_secret_iam_policy" "policy" {
  project     = google_secret_manager_secret.github_token_secret.project
  secret_id   = google_secret_manager_secret.github_token_secret.secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor.policy_data
}

data "google_secret_manager_secret_version" "latest_pac" {
  secret     = google_secret_manager_secret.github_token_secret.id
  project    = google_project.builder_project.project_id
  depends_on = [google_secret_manager_secret_version.github_token_secret_version]
}

resource "google_cloudbuildv2_connection" "connection" {
  count    = var.github_app_intigration_id != null ? 1 : 0
  project  = google_project.builder_project.id
  location = coalesce(var.location_build_triggers, var.default_location)
  name     = "github-connection"

  github_config {
    app_installation_id = var.github_app_intigration_id
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version.latest_pac.id
    }
  }

  depends_on = [google_project_service.cloud_build_service]

}
