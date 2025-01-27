variable "aws_region" {

  type = string

  default = "us-west-2"

}


variable "project_name" {

  type = string

  default = "demo"

}


variable "vpc_cidr" {

  type = string

  default = "10.0.0.0/16"

}


variable "public_subnet_cidrs" {

  type = list(string)

  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

}


variable "private_subnet_cidrs" {

  type = list(string)

  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

}


variable "availability_zones" {

  type = list(string)

  default = ["us-west-2a", "us-west-2b", "us-west-2c"]

}


variable "instance_ami" {

  type = string

  default = "ami-0fa40e25bf4dda1f6"

}


variable "instance_type" {

  type = string

  default = "t3.micro"

}
