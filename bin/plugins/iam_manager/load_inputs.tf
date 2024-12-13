# 1 "./plugins/iam_manager/load_inputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./plugins/iam_manager/load_inputs.tf" 2
# 1 "./plugins/iam_manager/../../managed_environment/managed_environment.h" 1





# 1 "./plugins/iam_manager/../../managed_environment/../helperfunctions.h" 1
# 7 "./plugins/iam_manager/../../managed_environment/managed_environment.h" 2
# 1 "./plugins/iam_manager/../../managed_environment/./place.h" 1
# 8 "./plugins/iam_manager/../../managed_environment/managed_environment.h" 2
# 2 "./plugins/iam_manager/load_inputs.tf" 2

locals {
  config_loaded = [for x in var.iam_configs : try(jsondecode(file(x)), [])]

  config_unpacked = merge(flatten([for x in local.config_loaded : [
    for binding in x : [
      for account in binding.accounts : {
        for role in binding.roles : sha256(format("%s%s%s", binding.target, account, role)) =>
        {
          target = binding.target
          sa     = account
          role   = role
        }
      }
    ]
  ]])...)


  config_places_deref = { for key, value in local.config_unpacked : key => {
    target = (coaless([for x in var.managed_environment : (x.name == value.target) ? x : null]...))
    name   = value.target
    sa     = value.sa
    role   = value.role
    }
  }

  config_no_bad_places = { for key, value in local.config_places_deref : key => value if value.target != null }

  iam_to_apply = local.config_no_bad_places


}
