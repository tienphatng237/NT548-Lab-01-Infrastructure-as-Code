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

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "jenkins_master_private_ip" {
  value = module.jenkins_master.private_ip
}

output "jenkins_worker_private_ip" {
  value = module.jenkins_worker.private_ip
}
