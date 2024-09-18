provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_cidr        = var.vpc_cidr
  public_subnet  = var.public_subnet
  route_cidr_block = var.route_cidr_block
}

module "security_group" {
  source = "./modules/security_group"
  vpc_id = module.vpc.vpc_id
  ingress_rules = var.security_group_ingress
  egress_rules  = var.security_group_egress
}

module "ec2" {
  source            = "./modules/ec2"
  public_subnet    = module.vpc.public_subnet
  security_group_id = module.security_group.security_group_id
  instance_type     = var.instance_type
  ami               = var.ami
  tags              = var.instance_tags
  key_name          = var.key_name
}

output "ec2_instance_public_ips" {
  value = module.ec2.instance_public_ips
}
