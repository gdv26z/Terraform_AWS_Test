

provider "aws" {
  region = var.region
}


resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block_vpc
  instance_tenancy = "default"

  tags = {
    Name = "Alexey-vpc-terraform"
  }
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Alexey-gateway-terraform"
  }

}

# Create Route Table and Add Public Route
# terraform aws create route table

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "Alexey-Public Route Table-terraform"
  }
}



data "aws_availability_zones" "available" {
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "11.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_a
  tags = {
    Name = "Alexey-public-alexey-subnet-1--terraform"
  }
}
resource "aws_subnet" "public-subnet-2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "11.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone_b
  tags = {
    Name = "Alexey-public-alexey-subnet-1--terraform"
  }
}


# Create Private Subnet 1
# terraform aws create subnet
resource "aws_subnet" "private-subnet-1" {

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "11.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone_a

  tags = {
    Name = "Alexey-private-alexey-subnet-2-terraform"
  }
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-1a.id
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
  subnet_id                   = aws_subnet.public-subnet-1a.id
  associate_public_ip_address = true
  tags = {
    Name = "Alexey-EC2-PUBLIC-terraform"
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
    Name = "Alexey-EC2-PRIVATE-terraform"
  }
}




resource "aws_security_group" "alexey-secure-group" {
  name        = "web_server_secure_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "8081"]
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
    Name = "Alexey-web_servers-terraform"
  }
}

#create target group
resource "aws_lb_target_group" "demo" {
  name       = "alexey-tg"
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_instance.my_Amazon_linux, aws_instance.my_Amazon_linux2]
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/status"
    interval            = 10
  }
}
resource "aws_lb_target_group_attachment" "demo" {
  target_group_arn = aws_lb_target_group.demo.arn
  count            = 2
  target_id        = aws_instance.demo[count.index].id
  port             = 80
}

resource "aws_lb" "app_lb" {
  name                       = "Alexey-LB-terraform"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alexey-secure-group.id]
  subnets                    = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-2b.id]
  enable_deletion_protection = false

  tags = {
    Name = "Alexey-LB-terraform"
  }
}
resource "aws_lb_listener" "app_lb" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn

  }
}
