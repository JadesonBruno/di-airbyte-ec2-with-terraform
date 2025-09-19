# General variables
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
