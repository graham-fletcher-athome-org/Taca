locals{
    iam_dict = {for x in flatten([for binding in var.iam : 
                    [for builder in binding.builders :
                        [for role in binding.roles:{
                            name  = builder.name
                            sa     = builder.sa.email
                            role     = role
                            }
                        ]
                    ]
                ]) : format("%s%s",x.name,x.role) => x}

    iam_keys = to_set([for k,v in local.iam_dict:k])
}

output "joe" {
    value = local.iam_keys
}