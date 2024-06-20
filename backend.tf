# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}


terraform {
  backend "s3" {
    bucket = "kkloud1234"
    key = "global/mystatefile/terraform.tfstate"
    region = "us-east-1"
  }
}
