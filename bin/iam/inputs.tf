# 1 "./iam/inputs.tf"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 418 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "./iam/inputs.tf" 2
# 1 "./iam/../managed_environment/place.h" 1
# 2 "./iam/inputs.tf" 2
variable "target" {
  type = object({ name : string, id : string, type : string })
}

variable "iam" {
  type = list(object({
    builders : list(any)
    roles : list(string)
  }))
}
