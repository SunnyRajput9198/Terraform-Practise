terraform {
    required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "~> 6.0"
    }
    }
    backend "s3" {

        bucket = "tws-junoon-state-bucket-sunny-2026"
        key    = "terraform.tfstate"
        region = "us-east-2"

        dynamodb_table = "tws-junoon-dynamodb-table"
    }
}

# Configure the AWS Provider
provider "aws" {
    region = "us-west-2"
}
