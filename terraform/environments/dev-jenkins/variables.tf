variable "ami_id" {}

variable "bastion_instance_type" {}

variable "jenkins_master_instance_type" {}

variable "jenkins_worker_instance_type" {}

variable "public_subnet_id" {
  type    = string
  default = "dummy"
}

variable "private_subnet_id" {
  type    = string
  default = "dummy"
}

variable "key_name" {
  type    = string
  default = "dummy"
}
