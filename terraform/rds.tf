resource "aws_db_subnet_group" "subnet-group" {
  subnet_ids = [aws_subnet.dbsubnet-1a.id, aws_subnet.dbsubnet-1c.id]
  tags = {
    Name = "aws-subnet-group"
  }
}

resource "aws_db_instance" "aws-rds" {
  db_subnet_group_name   = aws_db_subnet_group.subnet-group.id
  engine                 = "mysql"
  db_name                = "aws-web"
  allocated_storage      = 100
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  multi_az               = true
  instance_class         = "db.t4g.micro"
  tags = {
    Name = "aws-web-rds"
  }
}
