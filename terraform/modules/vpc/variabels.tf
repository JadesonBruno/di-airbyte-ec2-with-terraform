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

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type = string
  default = "10.1.0.0/16"
}