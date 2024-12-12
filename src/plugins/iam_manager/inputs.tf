#include "../../managed_environment/managed_environment.h"

variable "iam_configs" {
  type    = list(string)
  default = []
}

variable "managed_environment" {
  type    = object(me_type)
}
