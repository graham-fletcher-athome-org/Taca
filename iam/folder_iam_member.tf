locals{
    is_folder_iam_member = startswith(var.target,"folders/")
    iam_apply = local.is_folder_iam_member ? local.iam_dict : {}
}
/*resource "google_folder_iam_member" "folder" {
  for_each = local.iam_apply
  folder   = var.target
  role     = each.value.role
  member   = format("serviceAccount:%s",each.value.sa)
}*/

output "bob" {
  value = local.iam_apply
}


