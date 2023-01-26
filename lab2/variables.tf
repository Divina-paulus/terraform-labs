#vpc
variable "vpc_cidr" {
  type        = string
  description = "vpc cidr"
}    

variable "vpc_name" {
  type        = string
  description = "vpc name"
}
# public-gw
variable "public-gw" {
  type        = string
  description = "public-gw"
}
#cidr_subnet

variable "cidr_subnet" {
  type        = list(any)
  description = "public subnet cidr + private subnet cidr"
}

variable "subnet_name" {
  type        = list(any)
  description = "public subnet name + private subnet name"
}
#
variable "cidr_public" {
  type        = string
  description = "cidr_public"
}

# variable "ipv6_cidr_block " {
#   type        = string
#   description = "ipv6_cidr_block"
# }

variable "public_route_table" {
  type        = string
  description = "route-table-name"
}

##
variable "private_route_table" {
  type        = string
  description = "private routing table"
}

variable "nat_gateway" {
  type        = string
  description = "nat gateway name"
}

variable "security_group" {
  type        = string
  description = "security group name"
}

variable "ami" {
  type        = string
  description = "ami for ec2"
}

variable "ec2_type" {
  type        = string
  description = "instance type"
}

variable "public_ec2_name" {
  type        = string
  description = "public instance name"
}

variable "private_ec2_name" {
  type        = string
  description = "private instance name"
}
