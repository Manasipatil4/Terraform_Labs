# ec2 using variable, provider, resource block 

#in provider.tf 
provider "aws" {
    region =  var.region
}


#in resource.tf
resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = "manasi"
    tags = {
      Name = "my-ec2"

    }
}

#in variable.tf
variable "region" {
    default = "eu-north-1"
}
variable "ami_id" {
    default = "ami-0aba19e56f3eaec05"
}
variable "instance_type" {
    default = "t3.micro"
}