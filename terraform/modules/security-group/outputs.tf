output "public_sg" { value = aws_security_group.public_ec2.id }
output "private_sg" { value = aws_security_group.private_ec2.id }