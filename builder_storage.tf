
module "logbucket_names" {
    for_each = local.triggers
    source = "./bucket_name"
    name = format("log-%s",each.key)
    foundation_code = local.foundation_code
}

resource "google_storage_bucket" "log_buckets" {
    for_each = local.triggers
    name          = module.logbucket_names[each.key].name
    location      = coalesce(var.location_log_buckets,var.default_location)
    storage_class = "STANDARD"
    uniform_bucket_level_access = true
    project = google_project.builder_project.project_id
    depends_on=[google_project_service.cs_service]
}

resource "google_storage_bucket_iam_member" "log_bucket_iam" {
  for_each = local.triggers
  bucket = google_storage_bucket.log_buckets[each.key].id
  role   = "roles/storage.objectCreator"
  member = format("serviceAccount:%s",google_service_account.builder_service_accounts[each.value.sa_name].email)
}


module "build_assets_bucket_names" {
    for_each = local.triggers
    source = "./bucket_name"
    name = format("ba-%s",each.key)
    foundation_code = local.foundation_code
}

resource "google_storage_bucket" "build_assets_buckets" {
    for_each = local.triggers
    name          = module.build_assets_bucket_names[each.key].name
    location      = coalesce(var.location_ba_buckets,var.default_location)
    storage_class = "STANDARD"
    uniform_bucket_level_access = true
    project = google_project.builder_project.project_id
    depends_on=[google_project_service.cs_service]
}

resource "google_storage_bucket_iam_member" "build_assets_buckets_iam" {
  for_each = local.triggers
  bucket = google_storage_bucket.build_assets_buckets[each.key].id
  role   = "roles/storage.objectUser"
  member = format("serviceAccount:%s",google_service_account.builder_service_accounts[each.value.sa_name].email)
}
