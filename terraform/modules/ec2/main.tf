resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = "t2.micro"

  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name

  associate_public_ip_address = var.associate_public_ip

  tags = {
    Name = var.name
  }
}
