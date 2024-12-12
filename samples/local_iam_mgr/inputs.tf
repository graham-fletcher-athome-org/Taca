variable "git_identity_token" {
  type      = string
  default   = null
  sensitive = true
}

variable "create_backend" {
  type      = bool
  default   = false
}

variable "root_location" {
  type      = string
}

variable "billing" {
  type      = string
}

variable "github_app_intigration_id" {
  type      = number
}

variable "github_organization" {
  type      = string
}