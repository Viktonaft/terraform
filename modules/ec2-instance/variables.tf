variable "ami" {
  description = "AMI"
  type = string
}
variable "instance_type" {
  description = "instance_type"
  type = string
}
variable "subnet_id" {
  description = "Subnet ID "
  type = string
}
variable "security_groups_name" {
  description = "SGs Name"
  type = string
}
variable "instance_name" {
  description = "Instance name"
  type = string
}
variable "instance_role" {
  description = "Instance role"
  type = string
}
variable "instance_env" {
  description = "Instance env"
  type = string
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the EC2 instance"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "The key name to use for the instance"
  type        = string
  default     = "terraform_ec2_key"
}