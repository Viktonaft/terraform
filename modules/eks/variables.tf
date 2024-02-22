variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "node_desired_size" {
  description = "List of subnet IDs for the EKS cluster"
  type        = string
}

variable "node_max_size" {
   description = "List of subnet IDs for the EKS cluster"
   type        = string
 }

variable "node_min_size" {
description = "List of subnet IDs for the EKS cluster"
type        = string
}