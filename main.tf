terraform {
  backend "s3" {
    bucket         = "rd-state-bucket"
    dynamodb_table = "state-lock"
    key            = "terraform.tfstate"
    encrypt        = true
    region         = "us-east-2"
  }
}

provider "aws" {
  region = var.region
}

data "external" "check_key" {
  program = ["bash", "${path.module}/check_key.sh"]

  query = {
    key_name = var.key_name
    region   = var.region
  }
}

resource "aws_key_pair" "key" {
  count      = data.external.check_key.result["exists"] == "false" ? 1 : 0
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

module "my_vpc" {
  source = "./modules/vpc"

  vpc_name        = "RD-VPC"
  vpc_cidr        = "10.0.0.0/16"
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  av_zone         = ["us-east-2a", "us-east-2b"]
}

module "sg-external" {
  source = "./modules/security_group"

  name_sg       = "external-sg"
  cidr_blocks   = "0.0.0.0/0"
  ingress_ports = [22, 8080, 8081, 443, 9306]
  vpc_id        = module.my_vpc.vpc_id
}

module "sg-internal" {
  source = "./modules/security_group"

  name_sg       = "internal-sg"
  cidr_blocks   = "0.0.0.0/0"
  ingress_ports = [22, 2222, 80, 443, 3306]
  vpc_id        = module.my_vpc.vpc_id
}

module "bastion_host" {
  source                      = "./modules/ec2-instance"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.public_subnet_ids[0]
  security_groups_name        = module.sg-external.sg_id
  key_name                    = try(aws_key_pair.key[0].key_name, var.key_name)
  associate_public_ip_address = true
  instance_name               = "bastion-host"
  instance_role               = "bastion"
  instance_env                = "production"

  depends_on = [aws_key_pair.key]
}

module "web_host" {
  count                       = 2
  source                      = "./modules/ec2-instance"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.private_subnet_ids[0]
  security_groups_name        = module.sg-internal.sg_id
  key_name                    = try(aws_key_pair.key[0].key_name, var.key_name)
  associate_public_ip_address = false
  instance_name               = "web-host"
  instance_role               = "web"
  instance_env                = "production"

  depends_on = [aws_key_pair.key]
}

module "load_balancer" {
  source                      = "./modules/ec2-instance"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.public_subnet_ids[0]
  security_groups_name        = module.sg-external.sg_id
  key_name                    = try(aws_key_pair.key[0].key_name, var.key_name)
  associate_public_ip_address = true
  instance_name               = "loadbalancer"
  instance_role               = "lb"
  instance_env                = "production"

  depends_on = [aws_key_pair.key]
}

module "database" {
  source                      = "./modules/ec2-instance"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.private_subnet_ids[0]
  security_groups_name        = module.sg-internal.sg_id
  key_name                    = try(aws_key_pair.key[0].key_name, var.key_name)
  associate_public_ip_address = false
  instance_name               = "database"
  instance_role               = "db"
  instance_env                = "production"

  depends_on = [aws_key_pair.key]
}

module "database2" {
  source                      = "./modules/ec2-instance"
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = module.my_vpc.private_subnet_ids[0]
  security_groups_name        = module.sg-internal.sg_id
  key_name                    = try(aws_key_pair.key[0].key_name, var.key_name)
  associate_public_ip_address = false
  instance_name               = "database2"
  instance_role               = "db"
  instance_env                = "production"

  depends_on = [aws_key_pair.key]
}

output "bastion_host_public_ip" {
  value = module.bastion_host.instance_public_ip
}

output "load_balancer_public_ip" {
  value = module.load_balancer.instance_public_ip
}

output "web_host_private_ip_1" {
  value = module.web_host[0].instance_private_ip
}

output "web_host_private_ip_2" {
  value = module.web_host[1].instance_private_ip
}
output "database_private_ip" {
  value = module.database.instance_private_ip
}
output "database2_private_ip" {
  value = module.database2.instance_private_ip
}
