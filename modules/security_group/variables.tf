variable "name_sg" {
  description = "The name of the SG."
  type = string
}

variable "vpc_id" {
  description = "The VPC ID."
  type = string
}

#variable "from_port" {
#  description = "The start range of the inbound port rule."
#  type = number
#}

#variable "to_port" {
#  description = "The end range of the inbound port rule."
#  type = number
#}

variable "cidr_blocks" {
  description = "The CDR Blocks for inbound traffic."
  type = string
}

variable "ingress_ports" {
  description = "List of ingress ports to allow"
  type        = list(number)
  default     = [22] # default ports, you can override this in your module call
}
