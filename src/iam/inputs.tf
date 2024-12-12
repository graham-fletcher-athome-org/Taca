#include "../managed_environment/place.h"
variable "target" {
  type = object(place)
}

variable "iam" {
  type = list(object({
    builders : list(any)
    roles : list(string)
  }))
}



