module "folder_name_content" {
  for_each        = toset(var.content_folder_names)
  source          = "../nameing_conventions/folder_name"
  name            = each.value
  foundation_code = local.foundation_code
}

resource "google_folder" "content_folder" {
  for_each            = toset(var.content_folder_names)
  display_name        = module.folder_name_content[each.value].name
  parent              = local.top_folder_id
  deletion_protection = false
}