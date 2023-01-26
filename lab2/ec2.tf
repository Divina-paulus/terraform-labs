
##########################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

}

resource "aws_network_interface" "ec2-network" {
  subnet_id   = aws_subnet.subnet[0].id
  private_ips = ["10.0.0.99"]
  tags = {
    Name = "primary_network_interface"
  }
}
#######################
resource "aws_security_group" "sg" {
  name        = var.security_group
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      = aws_vpc.iti-vpc.id

  ingress {
    description      = "SSH from Anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_public]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP from Anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [var.cidr_public]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.cidr_public]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.security_group
  }
}

resource "aws_instance" "public-ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.ec2_type
  subnet_id = aws_subnet.subnet[0].id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data = <<EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
  EOF
    tags = {
    Name = var.public_ec2_name
  }
}
resource "aws_instance" "private-ec2" {
  ami = data.aws_ami.ubuntu.id
  instance_type   = var.ec2_type
  subnet_id    = aws_subnet.subnet[1].id
  vpc_security_group_ids = [aws_security_group.sg.id]



  user_data = <<-EOF
  #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
  EOF

  tags = {
    Name = var.private_ec2_name
  }
}
###########

# resource "aws_security_group" "SG" {
#   name        = var.security_group
#   description = var.security_group
#   vpc_id      = aws_vpc.iti-vpc.id

#   ingress {
#     description = "http"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [var.cidr_public]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = [var.cidr_public]
#   }

#   tags = {
#     Name = var.security_group
#   }
# }

# resource "aws_instance" "public-ec2" {
#   ami                         = var.ami
#   instance_type               = var.ec2_type
#   subnet_id                   = aws_subnet.subnet[0].id
#   associate_public_ip_address = true
#   vpc_security_group_ids             = [aws_security_group.SG.id]


#   user_data = <<-EOF
#   #!/bin/bash
#   yum update -y
#   yum install -y httpd.x86_64
#   systemctl start httpd.service
#   systemctl enable httpd.service
#   EOF

#   tags = {
#     Name = var.public_ec2_name
#   }
# }

# resource "aws_instance" "private-ec2" {
#   ami                         = var.ami
#   instance_type               = var.ec2_type
#   subnet_id                   = aws_subnet.subnet[1].id
#   vpc_security_group_ids            = [aws_security_group.SG.id]



#   user_data = <<-EOF
#   #!/bin/bash
#   yum update -y
#   yum install -y httpd.x86_64
#   systemctl start httpd.service
#   systemctl enable httpd.service
#   EOF

#   tags = {
#     Name = var.private_ec2_name
#   }
# }