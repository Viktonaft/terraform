variable "region" {
  description = "AWS region for the key pair"
  type        = string
  default     = "us-east-2"
}

variable "key_name" {
  description = "The name of the AWS key"
  type        = string
  default     = "terraform_ec2_key"
}

variable "public_key_path" {
  description = "Path to the public key to be used for the AWS key pair"
  type        = string
  default     = "terraform_ec2_key.pub"
}

variable "ami" {
  description = "The AMI to be used for the EC2 instance"
  type        = string
  default     = "ami-05fb0b8c1424f266b"
}

variable "instance_type" {
  description = "The instance type of the EC2 instance"
  type        = string
  default     = "t2.micro"
}

