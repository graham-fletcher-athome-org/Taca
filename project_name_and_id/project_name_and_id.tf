variable "name" {
  type    = string
  validation {
    condition     = length(var.name) <= 10 && length(var.name) >= 4
    error_message = "The base name of a project should be between 4 and 10 charecters"
  }
}

variable "foundation_code" {
  type    = string
  validation {
    condition     = length(var.foundation_code) == 4
    error_message = "The foundation code should be 4 charecters"
  }
}

resource "random_id" "rid" {
  byte_length = 8
}

output "name" {
  value = format("%s-%s",var.foundation_code,var.name)
}

output "id" {
  value = format("p%s-%s",var.foundation_code,random_id.rid.hex)
}