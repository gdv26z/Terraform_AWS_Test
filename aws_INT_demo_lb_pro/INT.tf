

provider "aws" {
  region = var.region
}




resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "Alexey-gateway-terraform"
  }

}


#Create ec2 instances
resource "aws_instance" "my_Amazon_linux" {
  count                       = 2
  ami                         = "ami-0a1ee2fb28fe05df3" #Amazon Linux AMI
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.alexey-secure-group.id]
  subnet_id                   = aws_subnet.public-subnet-1a.id
  key_name                    = "alexeymihaylov_key"
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")
  tags = {
    Name = "Alexey-EC2-PUBLIC-terraform-${count.index}"
  }
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
