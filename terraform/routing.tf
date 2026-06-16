# ルート記載（igw）
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags {
    Name = "route_igw"
  }
}

# ルート記載（nat）
resource "aws_route_table" "private-az1" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-az1.id
  }
  tags {
    Name = "route_nat1"
  }
}

resource "aws_route_table" "private-az2" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-az2.id
  }
  tags {
    Name = "route_nat2"
  }
}

# Subnet、RouteTableの紐づけ（igw）
resource "aws_route_table_association" "igw_az1" {
  subnet_id      = aws_subnet.public-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "igw_az2" {
  subnet_id      = aws_subnet.public-1c.id
  route_table_id = aws_route_table.public.id
}

# Subnet、RouteTableの紐づけ（nat）
resource "aws_route_table_association" "nat_az1" {
  subnet_id      = aws_subnet.private-1a.id
  route_table_id = aws_route_table.private-az1.id
}

resource "aws_route_table_association" "nat_az2" {
  subnet_id      = aws_subnet.private-1c.id
  route_table_id = aws_route_table.private-az2.id
}