# This block creates the main VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true # Gives the VPC access to the AWS DNS server
  enable_dns_hostnames = true # Gives instances "friendly" names (like ec2-54-1-2-3.compute-1.amazonaws.com)

  tags = {
    Name = "prod-vpc"
  }
}
# This block creates a internet gateway 
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "prod-igw"
  }
}
#This block creates a public subnet
resource "aws_subnet" "public" {
  count                   = 2 #count is used To create 2 subnets 
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index) # Takes the VPC range, adds 8 bits to the mask, and assigns a unique network address based on the index. [ count.index= This is the "index" or ID of the subnet you are creating. It determines the binary value of the new bits.]
  availability_zone       = element(["ap-south-1a", "ap-south-1b"], count.index)
  map_public_ip_on_launch = true
  tags                    = { Name = "public-${count.index}" }
}


# This block creates a private subnet
resource "aws_subnet" "private_app" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 10) # Here we are adding 10 to the count.index to create a different range for the private subnets. This ensures that the private subnets do not overlap with the public subnets.
  availability_zone = element(["ap-south-1a","ap-south-1b"], count.index)

  tags = {
    Name = "private-app-${count.index}"
  }
}

# This block creates another private subnet for the database layer
resource "aws_subnet" "private_db" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 20)
  availability_zone = element(["ap-south-1a","ap-south-1b"], count.index)

  tags = {
    Name = "private-db-${count.index}"
  }
}



# This block creates a route table for the public subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}
#This block creates a route to the internet gateway for the public route table
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id # here we are using the IGW created above 
}
# This block associates the public subnet with the public route table
resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}