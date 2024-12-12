#include "../managed_environment/place.h"
variable "target" {
  type = object(place_type)
}

variable "iam" {
  type = list(object({
    builders : list(any)
    roles : list(string)
  }))
}



