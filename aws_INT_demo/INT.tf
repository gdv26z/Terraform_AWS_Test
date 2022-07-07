

provider "aws" {
  region = var.region
}


resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Alexey-vpc"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Alexey-gateway"
  }

}

# Create Route Table and Add Public Route
# terraform aws create route table

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "Public Route Table"
  }
}



data "aws_availability_zones" "available" {
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "public-alexey-subnet-1"
  }
}

# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "eu-central-1a"

  tags = {
    Name = "private-alexey-subnet-2"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public-route-table.id
}


# resource "aws_eip_association" "eip_assoc" {
#   instance_id   = aws_instance.my_Amazon_linux.id
#   allocation_id = "eipalloc-02ea054c8065f1c11"
# }


resource "aws_instance" "my_Amazon_linux" {
  # count                  = var.prefix
  ami                         = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.alexey-secure-group.id]
  subnet_id                   = aws_subnet.public-subnet-1.id
  associate_public_ip_address = true
  tags = {
    Name = "EC2-PUBLIC"
  }
}


resource "aws_instance" "my_Amazon_linux2" {
  # count                  = var.prefix
  ami                         = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.alexey-secure-group.id]
  subnet_id                   = aws_subnet.private-subnet-1.id
  associate_public_ip_address = false
  tags = {
    Name = "EC2-PRIVATE"
  }
}




resource "aws_security_group" "alexey-secure-group" {
  name        = "web_server_secure_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092", "9093", "8081"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_servers"
  }
}
