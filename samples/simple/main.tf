module "secure" {
  source = "github.com/graham-fletcher-athome-org/scaffold"
  github_app_intigration_id = xxx
  billing = "xxx"
  root_location = "organizations/xxx"
  root_name = "BIP" 
  bootstrap_repo = "https://github.com/xxx" 
  content_folder_names = []
  builders = [] 
}