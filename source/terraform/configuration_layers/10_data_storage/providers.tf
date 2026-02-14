terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    key = "10_data_storage/terraform.tfstate"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      local.common_tags,
      {
        Layer = "10_data_storage"
      }
    )
  }
}
