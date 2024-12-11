# 1 "./iam/org_iam_member.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./iam/org_iam_member.tf" 2
locals {
  is_org_iam_member = (var.target.type == "o")
  iam_apply_org     = local.is_org_iam_member ? local.iam_dict : {}
}
resource "google_organization_iam_member" "org_member" {
  for_each = local.iam_apply_org
  org_id   = trimprefix(var.target.id, "organizations/")
  role     = each.value.role
  member   = format("serviceAccount:%s", each.value.sa)
}
