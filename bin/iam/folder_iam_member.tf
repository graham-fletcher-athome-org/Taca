# 1 "./iam/folder_iam_member.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./iam/folder_iam_member.tf" 2
locals {
  is_folder_iam_member = (var.target.type == "f")
  iam_apply            = local.is_folder_iam_member ? local.iam_dict : {}
}
resource "google_folder_iam_member" "folder" {
  for_each = local.iam_apply
  folder   = var.target.id
  role     = each.value.role
  member   = format("serviceAccount:%s", each.value.sa)
}
