variable "aws_region" {
  description = "AWS region for the resources"
  type        = string
}

variable "key_name" {
  description = "AWS key pair name"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "scheduler" {
  description = "Scheduler tag values for instances"
  type        = list(string)
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "private_ip" {
  description = "Private IP for the instance"
  type        = string
}

variable "existing_security_group_id" {
  description = "Existing security group ID"
  type        = string
}
