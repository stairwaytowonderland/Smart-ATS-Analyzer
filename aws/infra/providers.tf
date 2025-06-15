terraform {
  required_version = ">= 1.0.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.58.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      local.tags,
      {
        ManagedBy = "Terraform"
        Owner     = "Andrew Haller"
      }
    )
  }
}
