provider "aws" {
  region = var.service_region
}

terraform {
  backend "s3" {
    bucket = "bucket-name" # bucket for storing files of state aws services 
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
