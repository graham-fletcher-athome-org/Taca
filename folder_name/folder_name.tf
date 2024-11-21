variable "name" {
  type    = string
  validation {
    condition     = length(var.name) <20
    error_message = "The base name of a project should not exceed 20 charecters"
  }
}

variable "foundation_code" {
  type    = string
  validation {
    condition     = length(var.foundation_code) == 4
    error_message = "The foundation code should be 4 charecters"
  }
}

output "name" {
  value = format("f%s-%s",var.foundation_code,var.name)
}
