module "project_name_covention" {
    source = "./project_name_and_id"
    foundation_code = local.foundation_code
    name = "builder"
}

resource "google_project" "builder_project" {
  project_id = module.project_name_covention.id
  name = module.project_name_covention.name
  folder_id  = local.top_folder_id
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


