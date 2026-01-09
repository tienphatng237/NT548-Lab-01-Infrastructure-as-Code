variable "ami" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "key_name" {}
variable "name" {}

variable "associate_public_ip" {
  description = "Whether to assign a public IP"
  type        = bool
  default     = false
}
