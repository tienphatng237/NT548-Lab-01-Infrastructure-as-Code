################################
# Bastion (Public EC2)
################################
output "bastion_sg_id" {
  value = aws_security_group.bastion.id
}

################################
# Private EC2 (Jenkins Master / Worker)
################################
output "jenkins_master_sg_id" {
  value = aws_security_group.jenkins_master.id
}

output "jenkins_worker_sg_id" {
  value = aws_security_group.jenkins_worker.id
}
