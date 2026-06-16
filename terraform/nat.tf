resource "aws_eip" "eip-az1" {
  domain = "vpc"
  tags = {
    Name = "eip-az1"
  }
}

resource "aws_nat_gateway" "nat-az1" {
  vpc_id        = aws_vpc.main.id
  allocation_id = aws_eip.eip-az1.id
  tags = {
    Name = "aws-nat-az1"
  }
}

resource "aws_eip" "eip-az2" {
  domain = "vpc"
  tags = {
    Name = "eip-az2"
  }
}

resource "aws_nat_gateway" "nat-az2" {
  vpc_id        = aws_vpc.main.id
  allocation_id = aws_eip.eip-az2.id
  tags = {
    Name = "aws-nat-az2"
  }
}