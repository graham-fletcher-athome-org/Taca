resource "google_folder_iam_member" "folder" {
  for_each = {for key,value in local.iam_to_apply: key=>value if beginswith(value.target,"folder/")}
  folder   = each.value.target
  role     = each.value.role
  member   = each.value.sa
}
