# Public Subnet(az1,az2)
resource "aws_subnet" "public-1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "192.168.1.0/24"
  tags {
    Name = "public-az1"
  }
}

resource "aws_subnet" "public-1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "192.168.2.0/24"
  tags {
    Name = "public-az2"
  }
}

# Private Subnet(az1,az2)
resource "aws_subnet" "private-1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "192.168.11.0/24"
  tags {
    Name = "private-az1"
  }
}

resource "aws_subnet" "private-1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "192.168.12.0/24"
  tags {
    Name = "private-az2"
  }
}

# DB Subnet(az1,az2)
resource "aws_subnet" "dbsubnet-1a" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"
  cidr_block        = "192.168.21.0/24"
  tags {
    Name = "dbsubnet-az1"
  }
}

resource "aws_subnet" "dbsubnet-1c" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block        = "192.168.22.0/24"
  tags {
    Name = "dbsubnet-az2"
  }
}