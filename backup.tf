# terraform state file backup using s3
terraform {
  backend "s3" {
    bucket = "manasi-patil-student"
    key = "terraform.tfstate"
    region = "eu-north-1"
    
  }
}