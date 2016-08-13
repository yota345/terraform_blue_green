variable "blue_ami" {}
variable "blue_instance_type" {}
variable "auth_key_name" {}
variable "ssh_key_path" {}
variable "blue_instances_count" {}
variable "terraform_subnet_a" {}
variable "terraform_subnet_b" {}
variable "terraform_elb" {}
variable "terraform_ec2_security_group" {}


resource "aws_launch_configuration" "blue_launch_configuration" {
  image_id                    = "${var.blue_ami}"
  name                        = "blue-launch-configration"
  instance_type               = "${var.blue_instance_type}"
  key_name                    = "${var.auth_key_name}"
  security_groups             = ["${var.terraform_ec2_security_group}"]
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "blue_autoscaling_group" {
  name                      = "blue_autoscaling_group"
  launch_configuration      = "${aws_launch_configuration.blue_launch_configuration.name}"
  availability_zones        = ["ap-northeast-1a", "ap-northeast-1c"]
  vpc_zone_identifier       = ["${var.terraform_subnet_a}", "${var.terraform_subnet_b}"]
  load_balancers            = ["${var.terraform_elb}"]
  max_size                  = "${var.blue_instances_count}"
  min_size                  = "${var.blue_instances_count}"
  desired_capacity          = "${var.blue_instances_count}"
  health_check_grace_period = 120
  health_check_type         = "ELB"
  tag = {
    key = "Name"
    value = "blue_autoscaling_group"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_policy" "autoscaling_blue_scale_out" {
  name                   = "Blue-Instance-ScaleOut-CPU-High"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.blue_autoscaling_group.name}"
}


resource "aws_autoscaling_policy" "autoscaling_blue_scale_in" {
  name                   = "Blue-Instance-ScaleIn-CPU-Low"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.blue_autoscaling_group.name}"
}


resource "aws_cloudwatch_metric_alarm" "autoscaling_blue_cpu_high" {
  alarm_name          = "Blue-CPU-Utilization-High-30"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "50"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.blue_autoscaling_group.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.autoscaling_blue_scale_out.arn}"]
}


resource "aws_cloudwatch_metric_alarm" "autoscaling_blue_cpu_low" {
  alarm_name          = "Blue-CPU-Utilization-Low-20"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.blue_autoscaling_group.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.autoscaling_blue_scale_in.arn}"]
}


resource "aws_cloudwatch_metric_alarm" "autoscaling_blue_memory_high" {
  alarm_name          = "Blue-Memory-Utilization-High-70"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UsedMemoryPercent"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "60"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.blue_autoscaling_group.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.autoscaling_blue_scale_out.arn}"]
}


resource "aws_cloudwatch_metric_alarm" "autoscaling_blue_memory_low" {
  alarm_name          = "Blue-Memory-Utilization-Low-50"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "UsedMemoryPercent"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "20"
  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.blue_autoscaling_group.name}"
  }
  alarm_actions = ["${aws_autoscaling_policy.autoscaling_blue_scale_in.arn}"]
}
