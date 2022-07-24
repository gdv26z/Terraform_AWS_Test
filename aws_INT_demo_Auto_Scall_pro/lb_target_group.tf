#create target group
resource "aws_lb_target_group" "demo" {
  name     = "alexey-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    path                = "/status"
    interval            = 30
  }
}
