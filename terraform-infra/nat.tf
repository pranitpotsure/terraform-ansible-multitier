# This file defines the Elastic IP (EIP) resource that will be used for the NAT Gateway in the public subnet.
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "nat-eip"
  }
}
# This block creates a NAT Gateway in the public subnet and associates it with the Elastic IP (EIP) created above
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id  # NAT must be in PUBLIC subnet

  tags = {
    Name = "nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

# This block creates a route in the private route table to route all outbound traffic 
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

# This block creates a route in the private route table to route all outbound traffic 
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}
# This block associates the private route table with the private subnets to ensure that instances in the private subnets use the NAT Gateway for outbound internet access
resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
