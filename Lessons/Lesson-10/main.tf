#----------------------------------------------------------
# My Terraform
#
# Provision Resources in Multiply AWS Regions / Accounts
#
# Made by Alexey
#----------------------------------------------------------

provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "GER"
}

provider "aws" {
  region = "us-east-1"
  alias  = "USA"
}

data "aws_ami" "default_latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "usa_latest_ubuntu" {
  provider    = aws.USA
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "aws_ami" "ger_latest_ubuntu" {
  provider    = aws.GER
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

#===================================================================================================

resource "aws_instance" "my_ubuntu_ca" {
  ami           = data.aws_ami.default_latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Default server"
  }

}
resource "aws_instance" "my_ubuntu_eu" {
  provider      = aws.GER
  ami           = data.aws_ami.ger_latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "GER server"
  }
}
resource "aws_instance" "my_ubuntu_us" {
  provider      = aws.USA
  ami           = data.aws_ami.usa_latest_ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "USA server"
  }

}
