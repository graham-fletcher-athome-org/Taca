resource "google_folder_iam_member" "folder" {
  for_each = { for key, value in local.iam_to_apply : key => value if value.target.type == "f") }
  folder   = each.value.target.id
  role     = each.value.role
  member   = each.value.sa
}*/