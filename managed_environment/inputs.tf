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