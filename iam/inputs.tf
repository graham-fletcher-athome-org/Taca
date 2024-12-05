variable "target"{
    type = object(any)
}

variable "iam" {
    type = list(object({
                    builders   : list(any)
                    roles      : list(string)
    }))
}



