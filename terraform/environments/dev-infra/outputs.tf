output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  value = module.private_subnet.subnet_id
}

output "public_sg_id" {
  value = module.security_group.public_sg
}

output "private_sg_id" {
  value = module.security_group.private_sg
}

output "key_name" {
  value = module.key_pair.key_name
}