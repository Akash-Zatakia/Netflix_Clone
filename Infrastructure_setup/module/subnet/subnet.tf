variable "vpc_netflix_id" {
    type = string
}

resource "aws_subnet" "public_subnet" {
    vpc_id = var.vpc_netflix_id
    cidr_block = var.cidrblocks[0]
    tags = {
      Name = var.subnet_name_public
    }
    availability_zone = var.az
    map_public_ip_on_launch = true
}

output "public_subnet_id" {
    value = aws_subnet.public_subnet.id
}