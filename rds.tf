resource "aws_db_instance" "database" {
  identifier = "${var.RDS_NAME}-${var.ENVIRONMENT}"
  allocated_storage      = 10
  db_subnet_group_name   = aws_db_subnet_group.private_sg.id
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.DB_INSTANCE_TYPE
  multi_az               = true
  db_name                = var.DB_NAME
  username               = var.DATABASE_CREDENTIALS["username"]
  password               = var.DATABASE_CREDENTIALS["password"]
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  tags = {
    Name = "${var.RDS_NAME}-${var.ENVIRONMENT}"
  }
}