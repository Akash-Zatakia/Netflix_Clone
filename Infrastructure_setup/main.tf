provider "aws" {
    region = "us-east-1"
    profile = "default"
    shared_credentials_files = "/Users/akash/.aws/credentials"
    access_key = ""
    secret_key = ""
}

module "vpc" {
    source = "/module/vpc/"
}

module "subnet" {
    source = "/module/subnet/"
    vpc_netflix_id = module.vpc.vpc_netflix_id
}

module "security_groups" {
    source = "/module/security_groups/"
    vpc_netflix_id = module.vpc.vpc_netflix_id
}

module "gateway" {
    source = "/module/gateway/"
    vpc_netflix_id = module.vpc.vpc_netflix_id
    public_subnet_id = module.subnet.public_subnet_id
    code_guard_sg_id = module.security_groups.code_guard_sg_id
}

module "instances" {
    source = "/module/instances/"
    vpc_netflix_id = module.vpc.vpc_netflix_id
    public_subnet_id = module.subnet.public_subnet_id
    code_guard_sg_id = module.security_groups.code_guard_sg_id
    monitoring_server_sg_id = module.security_groups.monitoring_server_sg_id
    netflix_igw_id = module.gateway.netflix_igw_id
}

output "code_guard_ip" {
    value = module.instances.code_guard_ip
}

output "monitoring_server_ip" {
    value = module.instances.monitoring_server_ip
}