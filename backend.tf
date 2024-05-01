terraform {
  backend "s3" {
    bucket         = "my-bucket"
    key            = "project/terraform.tfstate"
    region         = "ap-south-1"
  }
}