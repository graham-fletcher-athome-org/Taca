locals {
    sa_names = toset([ for builder in var.builders : builder.sa_name if !strcontains(builder.sa_name, "@", )])
}

resource "google_service_account" "builder_service_accounts" {
  for_each = local.sa_names
  account_id = each.value
  project = google_project.builder_project.project_id
}