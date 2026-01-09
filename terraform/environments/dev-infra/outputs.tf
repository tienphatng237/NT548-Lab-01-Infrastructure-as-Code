#################
# VPC & Subnet #
#################
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.public_subnet.subnet_id
}

output "private_subnet_id" {
  value = module.private_subnet.subnet_id
}

####################
# Security Groups #
####################
output "bastion_sg_id" {
  value = module.security_group.bastion_sg_id
}

output "jenkins_master_sg_id" {
  value = module.security_group.jenkins_master_sg_id
}

output "jenkins_worker_sg_id" {
  value = module.security_group.jenkins_worker_sg_id
}

############
# Key Pair #
############
output "key_name" {
  value = module.key_pair.key_name
}
