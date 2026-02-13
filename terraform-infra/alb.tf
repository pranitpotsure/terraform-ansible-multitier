# this block creates an Application Load Balancer (ALB) that will be used to distribute incoming traffic to the web servers
resource "aws_lb" "public_alb" {
  name               = "public-alb"
  load_balancer_type = "application"                         #this defines type of Load Balancer 
  subnets            = aws_subnet.public[*].id               # this is used to attach both public subnets to the ALB, the [*] is used to get all the subnets created in public subnet and .id is used to get the id of those subnets
  security_groups    = [aws_security_group.public_alb_sg.id] # this is used to attach the security group created for public ALB to the ALB, we use .id because we need to attach the SG by its id and we put it in [] because we can attach multiple SGs to an ALB
}

# this block creates a target group for the web servers that will be registered with the public ALB, the target group is used to route traffic to the registered targets (web servers) based on the specified port and protocol
resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# this block creates a listener for the public ALB that listens on port 80 and forwards traffic to the web target group, the listener is used to define the protocol and port that the ALB will listen on and the default action to take when traffic is received (in this case, forward to the web target group)
resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

# this block creates an internal ALB that will be used to distribute traffic to the app servers, the internal ALB is only accessible within the VPC and is not exposed to the internet
resource "aws_lb" "internal_alb" {
  name               = "private-app-alb"
  internal           = true # this is used to specify that the ALB is internal and not exposed to the internet
  load_balancer_type = "application"
  subnets            = aws_subnet.private[*].id                # this is used to attach both private subnets to the internal ALB, the [*] is used to get all the subnets created in private subnet and .id is used to get the id of those subnets
  security_groups    = [aws_security_group.internal_alb_sg.id] # this is used to attach the security group created for internal ALB to the internal ALB
}

# this block creates a target group for the app servers that will be registered with the internal ALB, the target group is used to route traffic to the registered targets (app servers) based on the specified port and protocol
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 8080 # this is the port on which the app servers will be listening for traffic from the internal ALB
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# this block creates a listener for the internal ALB that listens on port 8080 and forwards traffic to the app target group, the listener is used to define the protocol and port that the internal ALB will listen on and the default action to take when traffic is received (in this case, forward to the app target group)
resource "aws_lb_listener" "internal_listener" {
  load_balancer_arn = aws_lb.internal_alb.arn
  port              = 8080
  protocol          = "HTTP"
  default_action { # this block defines the default action to take when traffic is received by the internal ALB, in this case, it forwards the traffic to the app target group
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn # this is used to specify the target group to which the traffic will be forwarded when received by the internal ALB
  }
}
