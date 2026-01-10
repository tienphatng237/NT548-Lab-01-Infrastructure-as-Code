############################
# Security Group - Bastion #
############################
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Allow SSH from personal IP"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-sg" }
}

#################################
# Security Group - Jenkins Master
#################################
resource "aws_security_group" "jenkins_master" {
  name        = "jenkins-master-sg"
  description = "SG for Jenkins Master"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "Jenkins UI from Bastion"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "jenkins-master-sg" }
}

#################################
# Security Group - Jenkins Worker
#################################
resource "aws_security_group" "jenkins_worker" {
  name        = "jenkins-worker-sg"
  description = "SG for Jenkins Worker"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from Jenkins Master"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_master.id]
  }

  ingress {
  description     = "SSH from Bastion"
  from_port       = 22
  to_port         = 22
  protocol        = "tcp"
  security_groups = [aws_security_group.bastion.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "jenkins-worker-sg" }
}
