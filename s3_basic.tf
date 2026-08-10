#This is basic s3 bucket creation

provider "aws" {
    region = "eu-north-1"  
}
resource "aws_s3_bucket" "mys3" {
    bucket = "manasi-bucket-sample"

    tags = {
        Name = "My bucket"

    }  
}


