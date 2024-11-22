check "input_checks" {
    assert {
        condition = (startswith(var.root_location,"folder/")) || (var.root_name != null)
        error_message = "Cannot be deployed in the root of an org without defining a top level folder"
    }
}