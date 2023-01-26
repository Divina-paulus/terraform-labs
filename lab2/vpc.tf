

/*==== The VPC ======*/
resource "aws_vpc" "iti-vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

 /*==== Subnets ======*/
 /* Internet gateway for the public subnet */
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.iti-vpc.id

  tags = {
    Name = var.public-gw
  }
}
#Subnet(public-private)
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.iti-vpc.id 
  count      = length(var.cidr_subnet)
  cidr_block = var.cidr_subnet[count.index]
  tags = {
    Name = var.subnet_name[count.index]
    
  }
}


# /* Routing table for public subnet */

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.iti-vpc.id 

  route {
    cidr_block= var.cidr_public
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block = "::/0"               #var.ipv6_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = var.public_route_table
  }
}

# public_route_table_association
resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.subnet[0].id
  route_table_id = aws_route_table.public-route-table.id
}

# private routing table 
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.iti-vpc.id

  route {
    cidr_block = var.cidr_public
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = var.private_route_table
  }
}
# private subnet association
resource "aws_route_table_association" "private-subnet-route" {
  subnet_id      = aws_subnet.subnet[1].id
  route_table_id = aws_route_table.private-route-table.id
}

#elastic ip
resource "aws_eip" "eip-nat" {
  vpc = true
}

# nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.subnet[0].id

  tags = {
    Name = var.nat_gateway
  }

  depends_on = [aws_internet_gateway.gw]
}
#-------------------
