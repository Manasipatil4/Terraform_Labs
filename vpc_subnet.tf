# creating vpc and subnet in aws using terraform

provider "aws" {
    region = "eu-north-1"
}

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16" 
    tags = {
        Name = "my-vpc-manasi"
    }
}


resource "aws_subnet" "my-subnet" {
    vpc_id = aws_vpc.my-vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "my-subnet-manasi"
    }
}

resource "aws_security_group" "my-sg" {
    name = "my-sg"
    vpc_id = aws_vpc.my-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }


}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.my-vpc.id

    tags = {
        Name = "my-igw-manasi"
    }
  
}

resource "aws_route_table" "my-route-table" {
    vpc_id = aws_vpc.my-vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "my-route-table-manasi"
    }
}    

resource "aws_route_table_association" "my-route-table-association" {
    subnet_id = aws_subnet.my-subnet.id
    route_table_id = aws_route_table.my-route-table.id
}