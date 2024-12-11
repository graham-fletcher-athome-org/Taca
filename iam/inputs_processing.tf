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

