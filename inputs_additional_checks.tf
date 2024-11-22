check "input_checks" {
    assert {
        condition = (startswith(var.root_location,"folder/")) || (var.root_name != null)
        error_message = "Cannot be deployed in the root of an org without defining a top level folder"
    }

    assert {
        condition = var.bootstrap_repo != null and var.github_app_intilation_id == null
        error_message = "A bootstrap repo cannot be defined until the github integration is complete and the integration id provided in input github_app_intigration_id"
    }
}