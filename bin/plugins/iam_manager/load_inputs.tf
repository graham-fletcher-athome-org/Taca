# 1 "./plugins/iam_manager/load_inputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./plugins/iam_manager/load_inputs.tf" 2
# 1 "./plugins/iam_manager/../../managed_environment/managed_environment.h" 1
# 2 "./plugins/iam_manager/load_inputs.tf" 2

locals {
  config_loaded = [for x in var.iamconfigs : jasondecode(file(x))]

  config_unpacked = merge(flatten([for x in local.config_loaded : [
    for binding in x : [
      for account in binding.accounts : {
        for role in binding.roles : binding.id =>
        {
          target = binding.target
          sa     = account
          role   = role
        }
      }
    ]
  ]]))

  config_places_deref = { for key, value in local.config_unpacked : key => {
    target = try(var.managed_environment.places[value.target], null)
    sa     = value.sa
    role   = value.role
    }
  }

  config_no_bad_places = { for key, value in local.config_places_deref : key => value if value.target != null }

  config_no_builder_sa = { for key, value in local.config_no_bad_places : key => value if regexall(var.managed_environment.builder_project_id, value.sa) == 0 }


  iam_to_apply = config_no_builder_sa


}
