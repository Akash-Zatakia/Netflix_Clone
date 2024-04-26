variable "vpc_netflix_id" {
    type = string
}

resource "aws_security_group" "code_guard_sg" {
    name = "code_guard_sg"
    description = "Security group for jenkins, trivy, sonarqube"
    vpc_id = var.vpc_netflix_id
    ingress = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "Jenkins port"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      description = "SonarQube port"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

    egress = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "All traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

resource "aws_security_group" "monitoring_server_sg" {
    name = "monitoring_server_sg"
    description = "Security group for Prometheus & grafana"
    vpc_id = var.vpc_netflix_id
    ingress =[ 
    {
        description = "Allow 9090 port"
        from_port   = 9090
        to_port     = 9090
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    },
    {
        description = "Allow 3000 port"
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ]
    egress = [
    {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        description = "All traffic"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ]
}

output "code_guard_sg_id" {
    value = aws_security_group.code_guard_sg.id
}

output "monitoring_server_sg_id" {
    value = aws_security_group.monitoring_server_sg.id
}