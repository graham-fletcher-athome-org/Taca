# 1 "./builder/inputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./builder/inputs.tf" 2
# 1 "./builder/../managed_environment/managed_environment.h" 1
# 2 "./builder/inputs.tf" 2

variable "managed_environment" {
  type = object({ places : object({}), git_hub_connection : string, builder_project : string, default_location : string, location_build_triggers : string, foundation_code : string, git_hub_enabled : bool, github_identity_token_secret : string })
}

variable "name" {
  type = string
}

variable "uri" {
  type    = string
  default = null
}

variable "location_log_buckets" {
  type    = string
  default = null
}

variable "location_ba_buckets" {
  type    = string
  default = null
}

variable "file_name" {
  type    = string
  default = "cloudbuild.yaml"
}

variable "branch" {
  type    = string
  default = ".*"
}

variable "included_files" {
  type    = list(string)
  default = null
}

variable "ignored_files" {
  type    = list(string)
  default = null
}

variable "github_org" {
  type    = string
  default = "graham-fletcher-athome-org"
}

variable "make_backend" {
  type    = bool
  default = false
}
