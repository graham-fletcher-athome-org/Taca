# 1 "./plugins/iam_manager/inputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./plugins/iam_manager/inputs.tf" 2
# 1 "./plugins/iam_manager/../../managed_environment/managed_environment.h" 1
# 2 "./plugins/iam_manager/inputs.tf" 2

variable "iam_configs" {
  type    = list(string)
  default = []
}

variable "managed_environment" {
  type = object({ places : object(any), git_hub_connection : string, builder_project : string, default_location : string, location_build_triggers : string, foundation_code : string, git_hub_enabled : bool, github_identity_token_secret : string })
}
