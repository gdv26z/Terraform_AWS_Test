
# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.route_table
    gateway_id = aws_internet_gateway.internet-gateway.id
  }
  tags = {
    Name = "Alexey-Public Route Table-terraform"
  }
}


data "aws_availability_zones" "available" {
}

# Associate Public Subnet 1 to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-1-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-1a.id
  route_table_id = aws_route_table.public-route-table.id
}
resource "aws_route_table_association" "public-subnet-2b-route-table-association" {
  subnet_id      = aws_subnet.public-subnet-2b.id
  route_table_id = aws_route_table.public-route-table.id
}
