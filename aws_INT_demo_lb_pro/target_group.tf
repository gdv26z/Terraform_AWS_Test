#create target group
resource "aws_lb_target_group" "demo" {
  name       = "alexey-tg"
  port       = 8080
  protocol   = "HTTP"
  vpc_id     = aws_vpc.vpc.id
  depends_on = [aws_instance.my_Amazon_linux]
  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 5
    timeout             = 5
    path                = "/status"
    interval            = 30
  }
}

resource "aws_lb_target_group_attachment" "demo1" {
  count            = length(aws_instance.my_Amazon_linux)
  target_group_arn = aws_lb_target_group.demo.arn
  target_id        = aws_instance.my_Amazon_linux[count.index].id
  port             = 8080
}
