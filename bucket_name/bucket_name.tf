variable "name" {
  type    = string
  validation {
    condition     = length(var.name) <20
    error_message = "The base name of a bucket should not exceed 20 charecters"
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
  value = format("%s-%s-%s",var.foundation_code,var.name,random_id.rid.hex)
}
