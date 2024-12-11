# 1 "./nameing_conventions/folder_name/folder_name.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./nameing_conventions/folder_name/folder_name.tf" 2
variable "name" {
  type = string
  validation {
    condition     = length(var.name) < 20
    error_message = "The base name of a project should not exceed 20 charecters"
  }
}

variable "foundation_code" {
  type = string
  validation {
    condition     = length(var.foundation_code) == 4
    error_message = "The foundation code should be 4 charecters"
  }
}

output "name" {
  value = format("%s-%s", var.foundation_code, var.name)
}
