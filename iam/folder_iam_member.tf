locals{
    is_folder_iam_member = startswith(var.target,"folders/")
    iam_apply = local.is_folder_iam_member ? local.iam_keys : toset([])
}
resource "google_folder_iam_member" "folder" {
  for_each = local.iam_apply
  folder   = var.target
  role     = local.iam_dict[each.value].role
  member   = format("serviceAccount:%s",local.iam_dict[each.value].sa)
}



