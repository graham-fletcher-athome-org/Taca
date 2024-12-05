variable "target"{
    type = object({
        id: string
        type:   string
    })
}

variable "iam" {
    type = list(object({
                    builders   : list(any)
                    roles      : list(string)
    }))
}



