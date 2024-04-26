resource "aws_vpc" "netflix_clone" {
  cidr_block = var.cidrblocks[0]
  tags = {
    Name = var.vpcname
  }
}

output "vpc_netflix_id" {
  value = aws_vpc.netflix_clone.id
}