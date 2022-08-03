resource "aws_autoscaling_group" "Polybot-aws_autoscaling_group" {
  name                = "EX1-Polybot-autoscaling-group"
  desired_capacity    = 0
  max_size            = 0
  min_size            = 0
  vpc_zone_identifier = [aws_subnet.public-subnet-1a.id, aws_subnet.public-subnet-2b.id]

  launch_template {
    id      = aws_launch_template.EX1_polybot_temp.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "web_cluster_target_tracking_policy" {
  name                      = "polybot-target-tracking-policy"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.Polybot-aws_autoscaling_group.name
  estimated_instance_warmup = 200

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = "30"

  }
}
