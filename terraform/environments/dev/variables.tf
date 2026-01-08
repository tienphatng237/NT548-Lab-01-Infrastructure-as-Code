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

variable "key_name" {}
variable "public_key_path" {}


