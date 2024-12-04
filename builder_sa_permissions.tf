locals {
  sa_roles_list = var.github_app_intigration_id != null ? flatten([for builder in var.builders :
    [for iam in builder.iam :
      [for role in iam.roles : {
        sa_short     = builder.sa_name
        sa           = strcontains(builder.sa_name, "@") ? builder.sa_name : format("serviceAccount:%s", google_service_account.builder_service_accounts[builder.sa_name].email)
        folder_short = iam.content_folder_name
        folder       = contains(var.content_folder_names, iam.content_folder_name) ? google_folder.content_folder[iam.content_folder_name].id : iam.content_folder_name
        role         = role
        }
      ]
    ]
  ]) : []
}

resource "google_folder_iam_member" "folder" {
  for_each = { for x in local.sa_roles_list : format("%s.%s.%s", x.folder_short, x.role, x.sa_short) => x if startswith(x.folder_short,"folder")}
  folder   = each.value.folder
  role     = each.value.role
  member   = each.value.sa
}

resource "google_organization_iam_member" "org" {
  for_each = { for x in local.sa_roles_list : format("%s.%s.%s", x.folder_short, x.role, x.sa_short) => x if startswith(x.folder_short,"org")}
  org_id   = trimprefix(each.value.folder,"orgaizations/")
  role     = each.value.role
  member   = each.value.sa
}

resource "google_folder_iam_member" "boostrap_iam_f1" {
  count  = var.bootstrap_repo != null ? 1 : 0
  folder = local.top_folder_id
  role   = "roles/owner"
  member = format("serviceAccount:%s", google_service_account.builder_service_accounts["bootstrap"].email)
}

resource "google_folder_iam_member" "boostrap_iam_f2" {
  count  = var.bootstrap_repo != null ? 1 : 0
  folder = local.top_folder_id
  role   = "roles/resourcemanager.folderAdmin"
  member = format("serviceAccount:%s", google_service_account.builder_service_accounts["bootstrap"].email)
}

output "sid" {
  value = local.sa_roles_list
}


