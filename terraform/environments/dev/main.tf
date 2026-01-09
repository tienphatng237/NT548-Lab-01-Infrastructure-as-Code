module "vpc" {
  source = "../../modules/vpc"
  cidr = var.vpc_cidr
}

module "public_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.vpc.vpc_id
  cidr = var.public_subnet.cidr
  az = var.public_subnet.az
  name = var.public_subnet.name
  public = true
}

module "private_subnet" {
  source = "../../modules/subnet"
  vpc_id = module.vpc.vpc_id
  cidr = var.private_subnet.cidr
  az = var.private_subnet.az
  name = var.private_subnet.name
  public = false
}

module "igw" {
  source = "../../modules/igw"
  vpc_id = module.vpc.vpc_id
}

module "nat" {
  source = "../../modules/nat"
  public_subnet_id = module.public_subnet.subnet_id
}

module "public_rt" {
  source = "../../modules/route-table"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.public_subnet.subnet_id
  gateway_id = module.igw.igw_id
}

module "private_rt" {
  source = "../../modules/route-table"
  vpc_id = module.vpc.vpc_id
  subnet_id = module.private_subnet.subnet_id
  gateway_id = module.nat.nat_id
}

module "sg" {
  source = "../../modules/security-group"
  vpc_id = module.vpc.vpc_id
  my_ip = var.my_ip
}

module "public_ec2" {
  source    = "../../modules/ec2"
  ami       = var.ami_id
  subnet_id = module.public_subnet.subnet_id
  sg_id     = module.sg.public_sg
  key_name  = module.key_pair.key_name
  name      = "bastion-ec2"

  associate_public_ip = true
}


module "private_ec2" {
  source    = "../../modules/ec2"
  ami       = var.ami_id
  subnet_id = module.private_subnet.subnet_id
  sg_id     = module.sg.private_sg
  key_name  = module.key_pair.key_name
  name      = "private-ec2"

  associate_public_ip = false
}


module "key_pair" {
  source          = "../../modules/key-pair"
  key_name        = var.key_name
  public_key_path = var.public_key_path
}

