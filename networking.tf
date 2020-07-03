resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"

  tags = {
    "Name" = "main"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.inet_gateway.id
  }

  tags = {
    "Name" = "Public"
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    "Name" = "Default route table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_default_route_table.main.id
}

resource "aws_main_route_table_association" "private" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_default_route_table.main.id
}

resource "aws_internet_gateway" "inet_gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    "Name" = "inet-gateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [
    aws_internet_gateway.inet_gateway
  ]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id
}

resource "aws_default_network_acl" "acl_private" {
  #vpc_id = aws_vpc.main.id
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  subnet_ids = [
    aws_subnet.private.id
  ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }


}

resource "aws_network_acl" "acl_public" {
  vpc_id = aws_vpc.main.id
  subnet_ids = [
    aws_subnet.public.id
  ]

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
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
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public"
  }
}

resource "aws_security_group" "app_security_group" {
  name        = "app_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Internal access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      aws_vpc.main.cidr_block
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_security_group"
  }
}

resource "aws_security_group" "web_security_group" {
  name        = "web_security_group"
  description = "allow 80 and 443"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "80"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "443"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Internal access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      aws_vpc.main.cidr_block
    ]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_security_group"
  }

}
