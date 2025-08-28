variable "project_name" {
  description = "The name of the project"
  type = string
  default = "airbyte-aws"
}

variable "environment" {
  description = "The environment for the project"
  type = string
  default = "dev"

  validation {
    condition = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "aws_region" {
  description = "The AWS region to deploy resources"
  type = string
  default = "us-east-2"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.1.0.0/16"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type = string
  default = "t3.xlarge"
}

variable "allow_ips" {
  description = "List of IPs allowed to access the Airbyte Web UI"
  type = list(string)
}
