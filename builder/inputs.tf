variable "managed_environment" {
    type = object({
        places : object({}),
        git_hub_connection : string,
        builder_project : string,
        default_location : string,
        location_build_triggers : string,
        foundation_code :string
        git_hub_enabled : bool
    })
}

variable "name" {
    type = string
}

variable "uri" {
    type = string
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
  default  = "cloudbuild.yaml"
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