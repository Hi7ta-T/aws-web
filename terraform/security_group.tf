# ALB
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "alb_sg"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
  }
}

# EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ec2_sg"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb_sg.id]
    protocol        = "tcp"
  }
}

# RDS
resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "rds_sg"
  }

  ingress {
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.ec2_sg.id]
    protocol        = "tcp"
  }
}
