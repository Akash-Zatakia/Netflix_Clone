variable "cidrblocks" {
    type = list
    default = ["10.0.1.0/24"]
}

variable "subnet_name_public" {
    type = string
    default = "public_subnet"
}

variable "az" {
    type = string
    default = "us-east-1a"
}