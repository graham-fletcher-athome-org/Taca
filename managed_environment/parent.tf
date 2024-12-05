resource "random_id" "foundation_id" {
  byte_length = 2
}

locals {
  foundation_code = random_id.foundation_id.hex
}

module "folder_name" {
  count           = var.root_name == null ? 0 : 1
  source          = "./nameing_conventions/folder_name"
  name            = var.root_name
  foundation_code = local.foundation_code
}

resource "google_folder" "top_folder" {
  count               = var.root_name == null ? 0 : 1
  display_name        = module.folder_name[0].name
  parent              = var.root_location
  deletion_protection = false
}

locals {
  parent_id = var.root_name == null ? var.root_location : google_folder.top_folder[0].id
}
