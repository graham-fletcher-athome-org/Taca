module "project_name_covention" {
  source          = "../nameing_conventions/project_name_and_id"
  foundation_code = local.foundation_code
  name            = "builder"
}

resource "google_project" "builder_project" {
  project_id      = module.project_name_covention.id
  name            = module.project_name_covention.name
  folder_id       = local.parent_type == "f" ? local.parent_id : null
  org_id          = local.parent_type == "o" ? trimprefix(local.parent_id, "organizations/") : null
  billing_account = var.billing
  deletion_policy = "DELETE"
}

resource "google_project_service" "cloud_build_service" {
  project = google_project.builder_project.id
  service = "cloudbuild.googleapis.com"
}

resource "google_project_service" "sm_service" {
  project = google_project.builder_project.id
  service = "secretmanager.googleapis.com"
}

resource "google_project_service" "cs_service" {
  project = google_project.builder_project.id
  service = "storage.googleapis.com"
}

resource "google_project_service" "rm_service" {
  project = google_project.builder_project.id
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "su_service" {
  project = google_project.builder_project.id
  service = "serviceusage.googleapis.com"
}
