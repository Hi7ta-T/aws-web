resource "aws_nat_gateway" "nat-az1" {
  vpc_id = "aws_vpc.main.id"
  tags {
    Name = "aws-nat-az1"
  }
}

resource "aws_nat_gateway" "nat-az2" {
  vpc_id = "aws_vpc.main.id"
  tags {
    Name = "aws-nat-az2"
  }
}