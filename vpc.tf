

/*==== The VPC ======*/

resource "aws_vpc" "iti-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "iti-vpc"
  }
}

 /*==== Subnets ======*/
 /* Internet gateway for the public subnet */
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.iti-vpc.id

  tags = {
    Name = "public-gw"
  }
}
#Subnet
resource "aws_subnet" "subnet" {
  vpc_id     = aws_vpc.iti-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public-subnet"
  }
}


# /* Routing table for public subnet */

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.iti-vpc.id 

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "route-table"
  }
}
# route_table_association

resource "aws_route_table_association" "route_association" {
  subnet_id      = aws_subnet.subnet.id
  route_table_id = aws_route_table.route-table.id
}
#-------------------
