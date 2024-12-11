module "testing" {
  source                    = "github.com/graham-fletcher-athome-org/Taca//bin/managed_environment/"
  root_location             = "organizations/56428708073"
  root_name                 = "v2test"
  billing                   = "011B14-62BDBE-B95D53"
  content_folder_names      = ["f1", "f2"]
  github_app_intigration_id = 57145993
  github_identity_token     = var.git_identity_token
}

module "boot_strap" {
  source              = "github.com/graham-fletcher-athome-org/Taca//bin/builder/"
  managed_environment = module.testing
  name                = "bootstrap"
  depends_on          = [module.testing]
}

module "iam" {
  source = "github.com/graham-fletcher-athome-org/Taca//bin/iam/"
  target = module.testing.places.parent
  iam = [{
    builders : [module.boot_strap]
    roles : ["roles/resourcemanager.folderAdmin", "roles/owner"]
  }]
  depends_on = [module.testing, module.boot_strap]
}

data "google_secret_manager_secret_version" "latest_pac" {
  secret     = module.testing.github_identity_token_secret
  project    = module.testing.builder_project
  depends_on = [module.testing]
}

provider "github" {
  token = module.testing.git_hub_enabled ? data.google_secret_manager_secret_version.latest_pac.secret_data : null
  owner = "graham-fletcher-athome-org"
}

