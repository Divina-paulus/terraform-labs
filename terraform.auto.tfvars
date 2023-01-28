vpc_cidr   = "10.0.0.0/16"
vpc_name   = "my vpc"
public-gw = "public-gw"
cidr_subnet = ["10.0.0.0/24", "10.0.1.0/24"]
subnet_name =["public_subnet", "private_subnet"]
cidr_public = "0.0.0.0/0"
# ipv6_cidr_block = "::/0"
public_route_table = "route-table-public"

private_route_table = "route-table-private"
nat_gateway           = "nat"
security_group        = "security group"
ami                   = "ami-0b5eea76982371e91"
ec2_type              = "t2.micro"
public_ec2_name       = "public-ec2"
private_ec2_name      = "private-ec2"
