################################
# VPC
################################
module "vpc" {
  source = "../../modules/vpc"
  cidr   = var.vpc_cidr
}

################################
# Subnets
################################
module "public_subnet" {
  source = "../../modules/subnet"

  vpc_id = module.vpc.vpc_id
  cidr   = var.public_subnet.cidr
  az     = var.public_subnet.az
  name   = var.public_subnet.name
  public = true
}

module "private_subnet" {
  source = "../../modules/subnet"

  vpc_id = module.vpc.vpc_id
  cidr   = var.private_subnet.cidr
  az     = var.private_subnet.az
  name   = var.private_subnet.name
  public = false
}

################################
# Internet Gateway & NAT
################################
module "igw" {
  source = "../../modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source            = "../../modules/nat"
  public_subnet_id  = module.public_subnet.subnet_id
}

################################
# Route Tables
################################
module "public_rt" {
  source = "../../modules/route-table"

  vpc_id     = module.vpc.vpc_id
  subnet_id = module.public_subnet.subnet_id
  gateway_id = module.igw.igw_id
}

module "private_rt" {
  source = "../../modules/route-table"

  vpc_id     = module.vpc.vpc_id
  subnet_id = module.private_subnet.subnet_id
  gateway_id = module.nat.nat_id
}

################################
# Security Groups
################################
module "security_group" {
  source = "../../modules/security_group"

  vpc_id = module.vpc.vpc_id
  my_ip  = var.my_ip
}

################################
# Key Pair
################################
module "key_pair" {
  source          = "../../modules/key-pair"
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

################################
# EC2 - Bastion
################################
module "bastion" {
  source = "../../modules/ec2/bastion"

  name               = "bastion"
  ami_id             = var.ami_id
  instance_type      = var.bastion_instance_type
  subnet_id          = module.public_subnet.subnet_id
  key_name           = module.key_pair.key_name
  security_group_ids = [module.security_group.public_sg]
}

################################
# EC2 - Jenkins Master
################################
module "jenkins_master" {
  source = "../../modules/ec2/jenkins"

  name               = "jenkins-master"
  role               = "jenkins-master"
  ami_id             = var.ami_id
  instance_type      = var.jenkins_master_instance_type
  subnet_id          = module.private_subnet.subnet_id
  key_name           = module.key_pair.key_name
  security_group_ids = [module.security_group.private_sg]
}

################################
# EC2 - Jenkins Worker
################################
module "jenkins_worker" {
  source = "../../modules/ec2/jenkins"

  name               = "jenkins-worker"
  role               = "jenkins-worker"
  ami_id             = var.ami_id
  instance_type      = var.jenkins_worker_instance_type
  subnet_id          = module.private_subnet.subnet_id
  key_name           = module.key_pair.key_name
  security_group_ids = [module.security_group.private_sg]
}
