# Create Web Security Group
resource "aws_security_group" "web_sg" {
  name        = "${var.SECURITY_GROUPS_NAMES["web"]}-${var.ENVIRONMENT}" 
  description = "Allow HTTP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.SSH_WHITELIST_IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web-sg"
  }
}

# Create Database Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.SECURITY_GROUPS_NAMES["rds"]}-${var.ENVIRONMENT}"
  description = "Allow inbound traffic from application layer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 32768
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sG"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "${var.SECURITY_GROUPS_NAMES["efs"]}-${var.ENVIRONMENT}"
  vpc_id      = module.vpc.vpc_id
  description = "Allows efs access"

  ingress {
    description     = "Allow traffic from application layer"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    # security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}