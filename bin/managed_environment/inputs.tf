# 1 "./managed_environment/inputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./managed_environment/inputs.tf" 2
variable "root_location" {
  type    = string
  default = "folders/514409708910"
}

variable "root_name" {
  type     = string
  default  = "testfoundation"
  nullable = true
}

variable "billing" {
  type = string
}

variable "content_folder_names" {
  type    = list(string)
  default = []
}

variable "github_app_intigration_id" {
  type     = number
  default  = null
  nullable = true
}

variable "default_location" {
  type    = string
  default = "europe-west2"
}

variable "location_log_buckets" {
  type    = string
  default = null
}

variable "location_ba_buckets" {
  type    = string
  default = null
}

variable "location_build_triggers" {
  type    = string
  default = null
}

variable "github_identity_token" {
  type      = string
  default   = null
  sensitive = true
}
