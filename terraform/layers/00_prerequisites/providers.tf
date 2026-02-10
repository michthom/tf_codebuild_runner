terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration is managed per environment via -backend-config flags
  # Use -backend-config=<path-to-environment>.tfbackend during init
  backend "s3" {
    key = "00_prerequisites/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      local.common_tags,
      {
        Layer = "00_prerequisites"
      }
    )
  }
}
