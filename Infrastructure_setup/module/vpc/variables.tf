variable "cidrblocks" {
  type = list
  default = ["10.0.0.0/16"]
}

variable "vpcname" {
  type = string
  default = "netflix_clone"
}