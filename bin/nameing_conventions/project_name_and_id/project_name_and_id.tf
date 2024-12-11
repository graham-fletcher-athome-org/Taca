# 1 "./nameing_conventions/project_name_and_id/project_name_and_id.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./nameing_conventions/project_name_and_id/project_name_and_id.tf" 2
variable "name" {
  type = string
  validation {
    condition     = length(var.name) <= 10 && length(var.name) >= 4
    error_message = "The base name of a project should be between 4 and 10 charecters"
  }
}

variable "foundation_code" {
  type = string
  validation {
    condition     = length(var.foundation_code) == 4
    error_message = "The foundation code should be 4 charecters"
  }
}

resource "random_id" "rid" {
  byte_length = 8
}

output "name" {
  value = format("%s-%s", var.foundation_code, var.name)
}

output "id" {
  value = format("p%s-%s", var.foundation_code, random_id.rid.hex)
}
