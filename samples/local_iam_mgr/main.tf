module "testing" {
  source                    = "github.com/graham-fletcher-athome-org/scaffold//bin/managed_environment/?ref=iam_mgr"
  root_location             = var.root_location
  root_name                 = "sample"
  billing                   = var.billing
  content_folder_names      = []
  github_app_intigration_id = var.github_app_intigration_id
  github_identity_token     = var.git_identity_token
}


module "boot_strap" {
  source              = "github.com/graham-fletcher-athome-org/scaffold//bin/builder/?ref=iam_mgr"
  managed_environment = module.testing
  name                = "bootstrap"
  depends_on          = [module.testing]
}

module "iam" {
  source = "github.com/graham-fletcher-athome-org/scaffold//bin/iam/?ref=iam_mgr"
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
  owner = var.github_organization
}

