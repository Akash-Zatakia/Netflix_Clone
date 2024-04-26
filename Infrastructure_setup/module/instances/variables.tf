variable "ami_aws_linux" {
    type = string
    default = "ami-04e5276ebb8451442"
}

variable "instances" {
    type = list
    default = ["t2.large", "t2.medium"] 
}

variable "private_key_name" {
    type = string
    default = "terraform"
}

variable "ec2_user" {
    type = string
    default = "ec2-user"
}