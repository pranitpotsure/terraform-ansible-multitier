# this block creates a launch template for the web servers that will be used by the Auto Scaling Group (ASG) to launch instances
resource "aws_launch_template" "web_lt" {
  image_id             = "ami-0f58b397bc5c1f2e8" # this is the AMI ID that will be used to launch the web server instances
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_group_names = [aws_security_group.web_sg.name] # this is used to attach the security group created for web servers to the launch template
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
}

# this block creates a launch template for the app servers that will be used by the Auto Scaling Group to launch instances
resource "aws_launch_template" "app_lt" {
  image_id             = "ami-0f58b397bc5c1f2e8"
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_group_names = [aws_security_group.app_sg.name]
}

resource "aws_autoscaling_group" "app_asg" {
  min_size            = 2
  desired_capacity    = 2
  max_size            = 4
  vpc_zone_identifier = aws_subnet.private[*].id         # this is used to specify the subnets in which the ASG will launch instances, the [*] is used to get all the subnets created in private subnet
  target_group_arns   = [aws_lb_target_group.app_tg.arn] # this is used to specify the target group to which the instances launched by the ASG will be registered for load balancing by the internal ALB

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
}
