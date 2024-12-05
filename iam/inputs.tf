variable "target"{
    type = string
}

variable "iam" {
    type = list(object({
                    builders   : list(any)
                    roles      : list(string)
    }))
}



