# to create 5 intances at one and also make variable file seperate instead of hardcoding in the main file

provider "aws" {
    region = var.region
}

resource "aws_instance" "ec2" {
    count = 5
    ami= var.ami_id
    instance_type = var.instance_type
    key_name = "manasi"
    tags = {
        Name = "my_ec2 ${count.index + 1}"
    }    
}


variable "region"{
    default = "eu-north-1"
}

variable "ami_id" {
    default = "ami-0aba19e56f3eaec05"
}
variable instance_type{
    default = "t3.micro"
}

variable "instance_name" {
    default = "my-ec2-instance"
}



# here we need to make main.tf in which add provider and resource block
# make a serpeate variable.tf file in which add all the variables and their default values.
