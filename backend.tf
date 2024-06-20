# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}


terraform {
  backend "s3" {
    bucket = "kkloud1234"
    dynamodb_table = "statelock"
    key = "global/mystatefile/terraform.tfstate"
    encrypt = true
    region = "us-east-1"
  }
}
