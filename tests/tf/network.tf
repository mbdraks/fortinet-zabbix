# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.215.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "My-Zabbix-VPC"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "My-Zabbix-VPC-IGW"
  }
}

# Create subnets
# az1
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.215.0.0/27"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "Zabbix-Public-Subnet-1"
  }
}
resource "aws_subnet" "private-subnet-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.215.0.32/27"
  map_public_ip_on_launch = false
  availability_zone       = "${var.region}a"

  tags = {
    Name = "Zabbix-Private-Subnet-1"
  }
}

# Create the Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Zabix-Public-Route-Table"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Zabbix-Private-Route-Table"
  }
}

# Create Route Table Associations
# public
resource "aws_route_table_association" "public-subnet-association-1" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public.id
}

# private
resource "aws_route_table_association" "private-association-1" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private.id
}
