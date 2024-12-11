#include "../../managed_environment/managed_environment.h"

variable "iam_configs" {
  type    = list(string)
  default = []
}

variable "managed_environment" {
  type    = me_type
}

variable "builder_project_id" {
  type = string
}