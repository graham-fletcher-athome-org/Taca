resource "google_secret_manager_secret" "github_token_secret" {
  count = var.github_connection_id == null ? 1 : 0

  project   = google_project.builder_project.project_id
  secret_id = "github"

  replication {
    auto {}
  }

  depends_on = [google_project_service.sm_service]
}

resource "google_secret_manager_secret_version" "github_token_secret_version" {
  count = var.github_connection_id == null ? 1 : 0

  secret      = google_secret_manager_secret.github_token_secret[0].id
  secret_data = "add pac here"
}

data "google_iam_policy" "serviceagent_secretAccessor" {
  count = var.github_connection_id == null ? 1 : 0

  binding {
    role    = "roles/secretmanager.secretAccessor"
    members = [format("serviceAccount:service-%s@gcp-sa-cloudbuild.iam.gserviceaccount.com", google_project.builder_project.number)]
  }
}

resource "google_secret_manager_secret_iam_policy" "policy" {
  count       = var.github_connection_id == null ? 1 : 0
  project     = google_secret_manager_secret.github_token_secret[0].project
  secret_id   = google_secret_manager_secret.github_token_secret[0].secret_id
  policy_data = data.google_iam_policy.serviceagent_secretAccessor[0].policy_data
}

data "google_secret_manager_secret_version" "latest_pac" {
  count      = var.github_connection_id == null ? 1 : 0
  secret     = google_secret_manager_secret.github_token_secret[0].id
  project    = google_project.builder_project.project_id
  depends_on = [google_secret_manager_secret_version.github_token_secret_version[0]]
}

resource "google_cloudbuildv2_connection" "connection" {
  count    = var.github_connection_id == null && var.github_app_intigration_id != null ? 1 : 0
  project  = google_project.builder_project.id
  location = coalesce(var.location_build_triggers, var.default_location)
  name     = "github-connection"

  github_config {
    app_installation_id = var.github_app_intigration_id
    authorizer_credential {
      oauth_token_secret_version = data.google_secret_manager_secret_version.latest_pac[0].id
    }
  }

  depends_on = [google_project_service.cloud_build_service]
}

locals {
  git_hub_connection_id = try(google_cloudbuildv2_connection.connection[0].id, var.github_connection_id)
}

output "git_hub_connection_id" {
  value = local.git_hub_connection_id
}
