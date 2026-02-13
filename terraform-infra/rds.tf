# this block creates a DB subnet group for the RDS instance, which is used to specify the subnets in which the RDS instance will be launched. The subnet IDs are obtained from the private subnets created in the VPC.
resource "aws_db_subnet_group" "db_subnet" {
  subnet_ids = aws_subnet.private[*].id # this is used to specify the subnets in which the RDS instance will be launched, the [*] is used to get all the subnets created in private subnet 
}

# this block creates a security group for the RDS instance, which is used to specify the inbound and outbound traffic rules for the RDS instance. 
resource "aws_db_instance" "rds" {
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "appdb"
  username               = "admin"
  password               = "Admin123"
  multi_az               = true
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  skip_final_snapshot    = true
}
