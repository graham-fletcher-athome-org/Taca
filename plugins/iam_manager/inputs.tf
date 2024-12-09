variable iam_configs {
    type = list(string)
    default = []
}

variable managed_environment {
    type = map(any)
    default = {}
}

variable builder_project_id {
    type = string
}

