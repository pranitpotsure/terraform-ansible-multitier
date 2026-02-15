# this block creates a launch template for the web servers that will be used by the Auto Scaling Group (ASG) to launch instances
resource "aws_launch_template" "web_lt" {
  image_id = data.aws_ami.amazon_linux.id # this is used to specify the AMI ID to be used for launching instances, in this case we are using the most recent Amazon Linux 2023 AMI retrieved from the data source defined in data.tf
  instance_type        = var.instance_type
  key_name             = var.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id] # this is used to attach the security group created for web servers to the launch template
  user_data = base64encode(templatefile("${path.module}/userdata-web.sh", { # this is used to specify the user data script that will be executed when the instance is launched, the templatefile function is used to read the content of the userdata-web.sh file and replace any variables in it with the values provided in the second argument, in this case we are passing the dns name of the internal ALB to the user data script so that it can be used to configure the web server to communicate with the app servers through the internal ALB
  internal_alb_dns = aws_lb.internal_alb.dns_name # this is used to get the DNS name of the internal ALB and pass it as a variable to the user data script
  }))

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "web-instance"
    }
  }
}

# this block creates an Auto Scaling Group (ASG) for the web servers that will automatically scale the number of instances based on the specified desired capacity, minimum size, and maximum size. The ASG will use the launch template created above to launch instances and will register them with the target group of the public ALB for load balancing.
resource "aws_autoscaling_group" "web_asg" {
  min_size            = 2
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = aws_subnet.public[*].id # this is used to specify the subnets in which the ASG will launch instances, the [*] is used to get all the subnets created in public subnet 
  target_group_arns   = [aws_lb_target_group.web_tg.arn]

  launch_template { # this block specifies the launch template to be used by the ASG to launch instances 
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
  depends_on = [aws_lb_listener.public_listener]

}
# this block creates a target tracking scaling policy for the web ASG that will automatically scale the number of instances based on the average CPU utilization of the instances in the ASG, 
resource "aws_autoscaling_policy" "web_target_tracking" {
  name                   = "web-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}

#-------------------------------------------------------------------------------

# this block creates a launch template for the app servers that will be used by the Auto Scaling Group to launch instances
resource "aws_launch_template" "app_lt" {
  image_id = data.aws_ami.amazon_linux.id 
  instance_type        = var.instance_type
  key_name             = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id] # this is used to attach the security group created for app servers to the launch template
  user_data = base64encode(templatefile("${path.module}/userdata-app.sh", { # this is used to specify the user data script that will be executed when the instance is launched, 
  rds_endpoint = aws_db_instance.rds.address  
  db_name      = aws_db_instance.rds.db_name
  db_user      = aws_db_instance.rds.username
  db_password  = var.db_password
}))

   tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  min_size            = 2
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = aws_subnet.private_app[*].id  # this is used to specify the subnets in which the ASG will launch instances, the [*] is used to get all the subnets created in private subnet
  target_group_arns   = [aws_lb_target_group.app_tg.arn] # this is used to specify the target group to which the instances launched by the ASG will be registered for load balancing by the internal ALB

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  depends_on = [aws_lb_listener.internal_listener]

}

# this block creates a target tracking scaling policy for the app ASG that will automatically scale the number of instances based on the average CPU utilization of the instances in the ASG
resource "aws_autoscaling_policy" "app_target_tracking" {
  name                   = "app-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0
  }
}
