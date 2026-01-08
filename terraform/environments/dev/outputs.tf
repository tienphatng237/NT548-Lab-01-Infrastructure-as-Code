output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  value = module.private_subnet.subnet_id
}

output "nat_gateway_id" {
  value = module.nat.nat_id
}

output "public_ec2_id" {
  value = module.public_ec2.instance_id
}

output "private_ec2_id" {
  value = module.private_ec2.instance_id
}
