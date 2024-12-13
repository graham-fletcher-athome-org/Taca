#include "../managed_environment/place.h"

locals {
  is_folder_iam_member = (var.target.type == "f")
  iam_apply            = local.is_folder_iam_member ? local.iam_dict : {}
}
resource "google_folder_iam_member" "folder" {
  for_each = local.iam_apply
  folder   = place_get_id(var.target)
  role     = each.value.role
  member   = format("serviceAccount:%s", each.value.sa)
}


