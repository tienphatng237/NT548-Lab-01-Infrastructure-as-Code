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

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "public_key_path" {
  description = "Path to public SSH key"
  type        = string
}