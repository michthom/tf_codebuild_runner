terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key = "20_networking/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      local.common_tags,
      {
        Layer = "20_networking"
      }
    )
  }
}
