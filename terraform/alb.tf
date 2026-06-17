resource "aws_lb" "aws-alb" {
  subnets            = [aws_subnet.public-1a.id, aws_subnet.public-1c.id]
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  tags = {
    Name = "alb"
  }
}
