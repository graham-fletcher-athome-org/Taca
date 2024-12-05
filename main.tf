module "testing" {
    source = "./managed_environment"
    root_location = "organizations/56428708073"
    root_name = "v2test"
    billing = "011B14-62BDBE-B95D53"
    content_folder_names = []
    github_app_intigration_id = 57145993
}

module "boot_strap" {
    source = "./builder"
    managed_environment = module.testing
    name = "bootstrap"
    uri = "https://github.com/graham-fletcher-athome-org/bip-foundation.git"
}

module "iam" {
    source = "./iam"
    target = module.testing.places.parent
    iam = [{
        builders:[module.boot_strap]
        roles:["roles/resourcemanager.folderAdmin","roles/owner"]
    }]
}


