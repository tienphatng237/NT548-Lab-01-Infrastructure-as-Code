variable "region" {}
variable "vpc_cidr" {}

variable "public_subnet" {
  type = object({
    cidr = string
    az   = string
    name = string
  })
}

variable "private_subnet" {
  type = object({
    cidr = string
    az   = string
    name = string
  })
}

variable "my_ip" {}
variable "ami_id" {}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Path to public SSH key"
  type        = string
}

variable "bastion_instance_type" {
  description = "EC2 instance type for bastion host"
  type        = string
}

variable "jenkins_master_instance_type" {
  description = "EC2 instance type for Jenkins master"
  type        = string
}

variable "jenkins_worker_instance_type" {
  description = "EC2 instance type for Jenkins worker"
  type        = string
}
