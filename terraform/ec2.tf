# AMI取得
data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# EC2作成(az1,az2)
resource "aws_instance" "aws-ec2-az1" {
  subnet_id              = aws_subnet.private-1a.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  ami                    = data.aws_ami.ami.id
  instance_type          = "t4g.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name

  tags = {
    Name = "aws-ec2-az1"
  }
}

resource "aws_instance" "aws-ec2-az2" {
  subnet_id              = aws_subnet.private-1c.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  ami                    = data.aws_ami.ami.id
  instance_type          = "t4g.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2-profile.name

  tags = {
    Name = "aws-ec2-az2"
  }
}
