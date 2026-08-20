# to create 3 intances with different names

provider "aws" {
    region = var.region
}

resource "aws_instance" "ec2" {
    for_each = toset(["DEV", "TEST", "PROD"])
    #  for_each = var.servers
    ami= var.ami_id
    instance_type = var.instance_type
    key_name = "manasi"
    tags = {
        Name = each.key
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


/*
variable "servers" {
  type = map(string)

  default = {
    DEV  = "t3.micro"
    TEST = "t3.micro"
    PROD = "t3.micro"
  }
}
*/

