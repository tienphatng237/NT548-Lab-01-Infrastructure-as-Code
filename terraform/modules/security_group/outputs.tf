################################
# Bastion (Public EC2)
################################
output "public_sg" {
  description = "Security Group ID for public EC2 (Bastion host)"
  value       = aws_security_group.public_ec2.id
}

################################
# Private EC2 (Jenkins Master / Worker)
################################
output "private_sg" {
  description = "Security Group ID for private EC2 (Jenkins master & worker)"
  value       = aws_security_group.private_ec2.id
}
