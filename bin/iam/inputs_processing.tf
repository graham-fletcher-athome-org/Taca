# 1 "./iam/inputs_processing.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./iam/inputs_processing.tf" 2
locals {
  iam_dict = { for x in flatten([for binding in var.iam :
    [for builder in binding.builders :
      [for role in binding.roles : {
        name = builder.name
        sa   = builder.sa.email
        role = role
        }
      ]
    ]
  ]) : format("%s%s", x.name, x.role) => x }
}
