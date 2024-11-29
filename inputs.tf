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
  type    = string
}

variable "content_folder_names" {
  type    = list(string)
  default = []
}

variable "builders" {
  type = list(object({
    name : string
    sa_name : string
    repo : string
    branch : string
    ignored_files : string
    included_files : string
    filename : string
    folder_ids : map(any)
    iam : list(object({
      content_folder_name : string,
      roles : list(string)
    }))
  }))

  default = []

}

variable "github_connection_id" {
  type     = string
  default  = null
  nullable = true
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

variable "bootstrap_repo" {
  type     = string
  default  = null
  nullable = true
}

