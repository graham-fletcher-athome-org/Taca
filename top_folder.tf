resource "random_id" "foundation_id" {
  byte_length = 2
}

locals {
    foundation_code = random_id.foundation_id.hex
}

module "folder_name" {
  source = "./folder_name"
  name = var.root_name
  foundation_code = local.foundation_code
}

resource "google_folder" "top_folder" {
  display_name = module.folder_name.name
  parent       = var.root_location
  deletion_protection=false
}
