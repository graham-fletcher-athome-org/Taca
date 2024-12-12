#include "../managed_environment/managed_environment.h"

variable "managed_environment" {
  type = object(me_type)
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

