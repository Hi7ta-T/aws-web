resource "aws_db_subnet_group" "subnet-group" {
  subnet_ids = [aws_subnet.dbsubnet-1a.id, aws_subnet.dbsubnet-1c.id]
  tags = {
    Name = "aws-subnet-group"
  }
}

resource "aws_db_instance" "aws-rds" {
  db_subnet_group_name = aws_db_subnet_group.subnet-group.id
  engine               = "mysql"
  allocated_storage    = 100
  secutity_groups      = [aws_security_group.rds_sg.id]
  multi_az             = true

  tags = {
    Name = "aws-web-rds"
  }
}
