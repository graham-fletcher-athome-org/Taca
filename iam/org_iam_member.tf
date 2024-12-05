locals{
    is_org_iam_member = (var.target.type=="o")
    iam_apply_org = local.is_org_iam_member ? local.iam_dict : {}
}
/*resource "google_organization_iam_member" "org_member" {
  for_each = local.iam_apply_org
  org_id   = trimprefix(var.target,"organizations/")
  role     = each.value.role
  member   = format("serviceAccount:%s",each.value.sa)
}*/
