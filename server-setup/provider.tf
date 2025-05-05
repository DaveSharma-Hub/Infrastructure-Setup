terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.97.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "terraform/states/release.tfstate"
    region         = "<REGION>"
  }
}