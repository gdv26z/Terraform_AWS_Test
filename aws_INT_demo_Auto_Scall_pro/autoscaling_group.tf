resource "aws_autoscaling_group" "Alexey-aws_autoscaling_group" {
  name                = "Alexey-aws-autoscaling-group-terraform"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-2b.id]
  target_group_arns   = [aws_lb_target_group.demo.arn] #  A list of aws_alb_target_group ARNs, for use with Application or Network Load Balancing.

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "staging-web-cluster-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.Alexey-aws_autoscaling_group.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "30"

  }
}
