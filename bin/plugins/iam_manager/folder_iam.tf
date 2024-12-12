# 1 "./plugins/iam_manager/folder_iam.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./plugins/iam_manager/folder_iam.tf" 2
resource "google_folder_iam_member" "folder" {
  for_each = { for key, value in local.iam_to_apply : key => value if value.target.type == "f") }
  folder = each.value.target.id
  role = each.value.role
  member = each.value.sa
}*/
