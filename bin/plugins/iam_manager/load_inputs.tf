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
  config_loaded = [for x in var.iam_configs : try(jsondecode(file(x)), [])]

  config_unpacked = flatten([for x in local.config_loaded : [
    for binding in x : [
      for account in binding.accounts : {
        for role in binding.roles : sha256(format("%s%s%s", binding.target, sa, role)) =>
        {
          target = binding.target
          sa     = account
          role   = role
        }
      }
    ]
  ]])
  # 35 "./plugins/iam_manager/load_inputs.tf"
}

output "bob" {
  value = local.config_unpacked
}
