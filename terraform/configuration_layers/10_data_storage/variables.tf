variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stg, prd)"
  type        = string
  validation {
    condition     = contains(["dev", "stg", "prd"], var.environment)
    error_message = "Environment must be dev, stg, or prd."
  }
}

variable "project_name" {
  description = "Project name for resource naming and tagging"
  type        = string
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  sensitive   = true
}

variable "layer" {
  description = "Layer name (e.g., 00_prerequisites, 10_data_storage, etc.)"
  type        = string
}
