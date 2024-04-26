variable "vpc_netflix_id" {
    type = string 
}

variable "public_subnet_id" {
    type = string
}

variable "code_guard_sg_id" {
    type = string
}

variable "monitoring_server_sg_id" {
    type = string
}

variable "netflix_igw_id" {
    type = string 
}

resource "aws_instance" "code_guard" {
    ami = var.ami_aws_linux
    instance_type = var.instances[0]
    key_name = var.private_key_name
    monitoring = true
    vpc_security_group_ids = [var.code_guard_sg_id]
    subnet_id = var.public_subnet_id
    tags = {
        Name = "code_guard"
        Environment = "dev"
        Terraform = "true"
    }
    root_block_device {
        delete_on_termination = true
        volume_size = 20
    }
    connection {
        type = "ssh"
        host = self.public_ip
        private_key = "${file("/Users/akash/Documents/Devops/Netflix_Clone/Infrastructure_setup/terraform.pem")}"
        user = var.ec2_user
    }

    provisioner "ansible" {
      plays{
        playbook{
            file_path = "/Users/akash/Documents/Devops/Netflix_Clone/Infrastructure_setup/ansible/code_guard.yaml"
        }
        enabled = true
        become = true
        hosts = ["${self.public_ip}"]
        verbose = true
      }
      ansible_ssh_settings {
        connection_timeout_seconds = 30
        connection_attempts = 30
        ssh_keyscan_timeout = 120
        insecure_no_strict_host_key_checking = true
      }
    }
}

resource "aws_instance" "monitoring_server" {
    ami = var.ami_aws_linux
    instance_type = var.instances[1]
    key_name = var.private_key_name
    monitoring = true
    vpc_security_group_ids = [var.monitoring_server_sg_id]
    subnet_id = var.public_subnet_id
    tags = {
        Name = "monitoring_server"
        Environment = "dev"
        Terraform = "true"
    }
    root_block_device {
        delete_on_termination = true
        volume_size = 25
        volume_type = "gp3"
    }
    connection {
        type = "ssh"
        host = self.public_ip
        private_key = "${file("/Users/akash/Documents/Devops/Netflix_Clone/Infrastructure_setup/terraform.pem")}"
        user = var.ec2_user
    }
    provisioner "file" {
        source = "/Users/akash/Documents/Devops/Netflix_Clone/Infrastructure_setup/configuration_files/prometheus.service"
        destination = "/tmp/prometheus.service"
    }
    provisioner "file" {
        source      = "/Users/akash/Documents/Devops/Netflix_Clone/Infrastructure_setup/configuration_files/grafana.repo"
        destination = "/tmp/grafana.repo"
    }
    provisioner "ansible" {
        plays{
            playbook{
                file_path = "/Users/akash/Documents/Devops/Netflix_Clone/Infrastructure_setup/ansible/monitoring_server.yaml"
            }
            enabled = true
            become = true
            hosts = ["${self.public_ip}"]
            verbose = true
        }
        ansible_ssh_settings {
        connection_timeout_seconds = 30
        connection_attempts = 30
        ssh_keyscan_timeout = 120
        insecure_no_strict_host_key_checking = true
        }
    }
}

output "code_guard_ip" {
    value = aws_instance.code_guard.public_ip
}

output "monitoring_server_ip" {
    value = aws_instance.monitoring_server.public_ip
}