resource "aws_lb" "aws-alb" {
  vpc_id             = aws_vpc.main.id
  subnet_ids         = [aws_subnet.public-1a.id, aws_subnet.public-1c.id]
  load_balancer_type = "application"
  secutity_groups    = "aws_security_group.alb_sg.id"
  tags {
    Name = "alb"
  }
}
