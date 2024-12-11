variable "git_identity_token" {
  type      = string
  default   = null
  sensitive = true
}

variable "create_backend" {
  type    = bool
  default = false
}