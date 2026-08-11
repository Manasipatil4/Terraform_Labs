# Terraform

## Terraform Definition

Terraform is an open-source Infrastructure as Code (IaC) tool developed by HashiCorp that allows you to define, provision, and manage infrastructure using configuration files.

It can manage resources across AWS, Azure, Google Cloud, Kubernetes, and many other providers.

## what is Infrastructure as Code
Infrastructure as Code (IaC) is the practice of creating, configuring, and managing IT infrastructure using code instead of manually doing it through a cloud console or GUI.

For example, instead of manually creating an AWS EC2 instance, VPC, subnet, security group, and S3 bucket, you write configuration files and a tool creates them automatically.

## What is HCL?

HCL (HashiCorp Configuration Language) is a declarative configuration language developed by HashiCorp and primarily used with Terraform to define and manage infrastructure.

It is designed to be human-readable and easy to write.


## terraform lifecycle
1. terraform init

Initializes the Terraform project and downloads required providers.
```bash
terraform init
```

Example: Terraform downloads the AWS provider.

2. terraform plan

Shows what Terraform will create, modify, or destroy without actually making changes.
```bash
terraform plan
```

Example:

+ aws_instance.web will be created

+ → Create
~ → Modify
- → Destroy

3.terraform apply

Actually creates or modifies the infrastructure.
```bash
terraform apply
```

Terraform asks for confirmation:

Do you want to perform these actions?
  Enter a value: yes


4.terraform destroy

Deletes resources managed by Terraform.

```bash
terraform destroy
```
⚠️ This can delete your actual AWS resources, so use it carefully.


## CloudFormation vs terraform


| Feature                      | CloudFormation                    | Terraform                                                      |
| ---------------------------- | --------------------------------- | -------------------------------------------------------------- |
| **Provider**                 | Native AWS service                | Developed by HashiCorp                                         |
| **Cloud Support**            | AWS only                          | Multi-cloud (AWS, Azure, GCP, Kubernetes, VMware, etc.)        |
| **Language**                 | YAML or JSON                      | HCL (HashiCorp Configuration Language)                         |
| **State Management**         | Managed by AWS                    | Uses a state file (local or remote)                            |
| **Execution**                | AWS handles deployments           | Terraform CLI (or Terraform Cloud/Enterprise) executes changes |
| **Learning Curve**           | Easier if you know AWS            | Easier syntax, but requires understanding state management     |
| **Cross-platform Resources** | No                                | Yes                                                            |
| **Modules/Templates**        | Nested stacks, modules            | Reusable modules with rich ecosystem                           |
| **Cost**                     | Free (pay only for AWS resources) | Open source; paid enterprise features available                |

## terraform blocks
1. Terraform Block

The Terraform block defines Terraform's own configuration, such as required Terraform version, providers, and backend.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}


Used for:
Terraform version
Provider requirements
Backend configuration
Provider configuration requirements.

2. Provider Block

The provider block tells Terraform which cloud/platform it should communicate with.

For AWS:

provider "aws" {
  region = "ap-south-1"
}

Here:

aws         → Provider
ap-south-1  → Mumbai region

For example, Terraform can use providers for:

AWS
Azure
Google Cloud
Kubernetes


3. Resource Block

The resource block is one of the most important Terraform blocks.

It defines infrastructure that Terraform should create or manage.

Example:

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "WebServer"
  }
}

Structure:

resource "RESOURCE_TYPE" "RESOURCE_NAME" {
  configuration
}

Here:

aws_instance → Resource type
web          → Resource name

Terraform can create:

EC2
VPC
Subnet
Security Group
S3 bucket
RDS
Load Balancer
IAM resources

4. Data Block

The data block is used to read existing information instead of creating a new resource.

Example: Find an existing AWS AMI:

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]
}

Then use it:

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

5. Module Block

A module is a reusable collection of Terraform configuration.

Suppose you have:

modules/
└── ec2/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf

You can call it from your main configuration:

module "web_server" {
  source = "./modules/ec2"

  instance_type = "t2.micro"
}

Instead of writing the same EC2 configuration repeatedly, you create it once as a module and reuse it.

Module
   ↓
Reusable Terraform code
   ↓
EC2 / VPC / RDS / etc.


6. Variable Block

A variable block allows you to pass values into your Terraform configuration.

Example:

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

Use it:

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = var.instance_type
}

You can override it:

terraform apply -var="instance_type=t3.micro"
Why variables?

Without variables:

instance_type = "t2.micro"

With variables:

instance_type = var.instance_type

This makes your Terraform code flexible and reusable.

7. Output Block

The output block displays useful information after Terraform creates infrastructure.

Example:

output "instance_public_ip" {
  value = aws_instance.web.public_ip
}

After:

terraform apply

Terraform may show:

instance_public_ip = "13.234.xx.xx"

You can output:

EC2 public IP
Load Balancer DNS
VPC ID
Subnet ID
RDS endpoint


8. Locals Block

The locals block defines reusable values or expressions inside your Terraform configuration.

Example:

locals {
  project_name = "employee-app"
  environment  = "production"

  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
  }
}

Use it:

resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = local.common_tags
}




