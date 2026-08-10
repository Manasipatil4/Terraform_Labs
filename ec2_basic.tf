# this is a basic terraform file to launch Ec2 instance

provider "aws" {
    region = "eu-north-1"  
}
resource "aws_instance" "ec2" {
    ami = "ami-0aba19e56f3eaec05"
    instance_type = "t3.micro"
    key_name = "manasi"

    tags = {
      Name = "my_ec2"
    } 
}