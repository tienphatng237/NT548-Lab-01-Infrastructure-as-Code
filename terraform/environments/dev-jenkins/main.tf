data "terraform_remote_state" "infra" {
  backend = "local"

  config = {
    path = "../dev-infra/terraform.tfstate"
  }
}

################################
# Bastion
################################
module "bastion" {
  source = "../../modules/ec2/bastion"

  name               = "bastion"
  ami_id             = var.ami_id
  instance_type      = var.bastion_instance_type
  subnet_id          = data.terraform_remote_state.infra.outputs.public_subnet_id
  key_name           = data.terraform_remote_state.infra.outputs.key_name
  security_group_ids = [data.terraform_remote_state.infra.outputs.public_sg_id]
}

################################
# Jenkins Master
################################
module "jenkins_master" {
  source = "../../modules/ec2/jenkins"

  name               = "jenkins-master"
  role               = "jenkins-master"
  ami_id             = var.ami_id
  instance_type      = var.jenkins_master_instance_type
  subnet_id          = data.terraform_remote_state.infra.outputs.private_subnet_id
  key_name           = data.terraform_remote_state.infra.outputs.key_name
  security_group_ids = [data.terraform_remote_state.infra.outputs.private_sg_id]
}

################################
# Jenkins Worker
################################
module "jenkins_worker" {
  source = "../../modules/ec2/jenkins"

  name               = "jenkins-worker"
  role               = "jenkins-worker"
  ami_id             = var.ami_id
  instance_type      = var.jenkins_worker_instance_type
  subnet_id          = data.terraform_remote_state.infra.outputs.private_subnet_id
  key_name           = data.terraform_remote_state.infra.outputs.key_name
  security_group_ids = [data.terraform_remote_state.infra.outputs.private_sg_id]
}
