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
  source           = "../../modules/nat"
  public_subnet_id = module.public_subnet.subnet_id
}

################################
# Route Tables
################################
module "public_rt" {
  source = "../../modules/route-table"

  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.public_subnet.subnet_id
  gateway_id = module.igw.igw_id
}

module "private_rt" {
  source = "../../modules/route-table"

  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.private_subnet.subnet_id
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
