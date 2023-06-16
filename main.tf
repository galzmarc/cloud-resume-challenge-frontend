terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1" # EU (Ireland)
}

# Configure the AWS Account ID as a variable
# The Account ID will be used to give a unique name to the S3 bucket
variable "account_id" {
  description = "AWS Account ID"
  type        = number
}