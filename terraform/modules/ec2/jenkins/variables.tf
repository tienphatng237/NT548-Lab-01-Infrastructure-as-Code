variable "name" {}
variable "role" {
  description = "jenkins-master | jenkins-worker"
}
variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "security_group_ids" {
  type = list(string)
}
variable "key_name" {}
