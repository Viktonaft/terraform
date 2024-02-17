variable "vpc_name" {
  description = "Name of VPC"
  type  = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type  = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnet CIDR blocks."
  type = list(string)
}

variable "private_subnets" {
  description = "List of private subnet CIDR blocks."
  type = list(string)
}

variable "av_zone" {
  description = "List of availability zones in the region"
  type = list(string)
}

