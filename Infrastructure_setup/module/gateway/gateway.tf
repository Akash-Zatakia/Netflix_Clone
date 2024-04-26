variable "vpc_netflix_id" {
    type = string
}

variable "public_subnet_id" {
    type = string
}

resource "aws_internet_gateway" "netflix_igw" {
    vpc_id = var.vpc_netflix_id
    tags = {
      Name = "Netflix Internet Gateway"
    }
}

resource "aws_route_table" "netflix_public_rt" {
    vpc_id = var.vpc_netflix_id
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.netflix_igw.id
    }
    tags = {
      Name = "netflix_public_rt"
    }
}

resource "aws_route_table_association" "netflix_public_rt_association" {
    subnet_id = var.public_subnet_id
    route_table_id = aws_route_table.netflix_public_rt.id
}

output "netflix_igw_id" {
    value = aws_internet_gateway.netflix_igw.id
}