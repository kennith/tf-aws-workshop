resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"

  tags = {
    "Name" = "main"
  }
}

resource "aws_internet_gateway" "inet-gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "inet-gateway"
  }
}

resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.1.0/24"

  tags = {
    Name = "Private"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.1.2.0/24"

  tags = {
    Name = "Public"
  }
}