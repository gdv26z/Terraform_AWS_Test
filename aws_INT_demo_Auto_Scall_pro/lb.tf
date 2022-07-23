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
