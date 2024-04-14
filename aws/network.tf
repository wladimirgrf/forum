resource "aws_vpc" "vpc_private" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "private-vpc"
  }
}

resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat_gateway_default" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet_public.id
  depends_on    = [aws_eip.nat_eip]

  tags = {
    Name = "nat-gateway-for-private-vpc"
  }
}

resource "aws_internet_gateway" "internet_gateway_default" {
  vpc_id = aws_vpc.vpc_private.id

  tags = {
    Name = "internet-gateway-for-private-vpc"
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.vpc_private.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnet-public-for-private-vpc"
  }
}


resource "aws_subnet" "subnet_private_a" {
  vpc_id            = aws_vpc.vpc_private.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-private-for-private-vpc-a"
  }
}

resource "aws_subnet" "subnet_private_b" {
  vpc_id            = aws_vpc.vpc_private.id
  cidr_block        = "10.0.30.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-private-for-private-vpc-b"
  }
}

resource "aws_subnet" "subnet_private_c" {
  vpc_id            = aws_vpc.vpc_private.id
  cidr_block        = "10.0.40.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "subnet-private-for-private-vpc-c"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_private.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway_default.id
  }

  tags = {
    Name = "route-table-public-for-private-vpc"
  }
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc_private.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_default.id
  }

  tags = {
    Name = "route-table-private-for-private-vpc"
  }
}

resource "aws_route_table_association" "route_table_association_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "route_table_association_private_a" {
  subnet_id      = aws_subnet.subnet_private_a.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "route_table_association_private_b" {
  subnet_id      = aws_subnet.subnet_private_b.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_route_table_association" "route_table_association_private_c" {
  subnet_id      = aws_subnet.subnet_private_c.id
  route_table_id = aws_route_table.route_table_private.id
}

resource "aws_security_group" "security_group_lambda" {
  name   = "lambda-security-group"
  vpc_id = aws_vpc.vpc_private.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
