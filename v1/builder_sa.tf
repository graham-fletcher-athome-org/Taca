locals {
  sa_names_d = toset([for builder in var.builders : builder.sa_name if !strcontains(builder.sa_name, "@", )])
  sa_names = var.bootstrap_repo != null ? (
    setunion(local.sa_names_d, toset(["bootstrap"]))
    ) : (
    local.sa_names_d
  )
}

resource "google_service_account" "builder_service_accounts" {
  for_each   = local.sa_names
  account_id = each.value
  project    = google_project.builder_project.project_id
}

output "builder_sa" {
  value = google_service_account.builder_service_accounts
}