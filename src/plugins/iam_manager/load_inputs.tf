#include "../../managed_environment/managed_environment.h"

locals {
    config_loaded = [for x in var.iam_configs : try(jsondecode(file(x)),[])]

    config_unpacked = merge(flatten([for x in local.config_loaded : [
                        for binding in x : [
                            for account in binding.accounts : {
                                for role in binding.roles: sha256(format("%s%s%s",binding.target,account,role)) =>
                                {
                                    target = binding.target
                                    sa     = account
                                    role   = role
                                }
                            }
                        ]
                    ]])...)
                    

    config_places_deref = {for key,value in local.config_unpacked: key=> {
                                                            target = me_name_to_place(var.managed_environment,value.target)
                                                            name   = value.target
                                                            sa     = value.sa
                                                            role   = value.role
                                                          } 
    }

    config_no_bad_places = {for key,value in local.config_places_deref : key=>value if value.target != null}

    iam_to_apply = local.config_no_bad_places


}
