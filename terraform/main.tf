terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.19.0"
    }
  }

  # DynamoDB locking not required as I'm the only one capable of accessing the state,
  # and I have no plans for automated applies or even plans.
  backend "s3" {
    bucket = "bradley-chatha-versioned"
    region = "eu-west-2"
    key    = "terraform/infra.tfstate"
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      "provisioner" = "terraform"
      "repository"  = "BradleyChatha/infra"
    }
  }
}