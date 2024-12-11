#include "../../managed_environment/managed_environment.h"

locals {
    config_loaded = [for x in var.iamconfigs : jasondecode(file(x))]

    config_unpacked = merge(flatten([for x in local.config_loaded : [
                        for binding in x : [
                            for account in binding.accounts : {
                                for role in binding.roles: binding.id =>
                                {
                                    target = binding.target
                                    sa     = account
                                    role   = role
                                }
                            }
                        ]
                    ]]))

    config_places_deref = {for key,value in local.config_unpacked: key=> {
                                                            target = me_deref_place(var.managed_environment,value.target)
                                                            sa     = value.sa
                                                            role   = value.role
                                                          } 
    }

    config_no_bad_places = {for key,value in local.config_places_deref : key=>value if value.target != null}

    config_no_builder_sa = {for key,value in local.config_no_bad_places : key=>value if regexall(var.managed_environment.builder_project_id,value.sa) == 0}


    iam_to_apply = config_no_builder_sa

    
}