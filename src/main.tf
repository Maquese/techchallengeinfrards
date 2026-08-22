terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_security_group" "clients" {
  id = var.client_security_group_id
}

resource "aws_security_group" "rds" {
  name   = "rds-sg"
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_clients" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds.id
  source_security_group_id = data.aws_security_group.clients.id
  description              = "Allow EKS and Lambda clients to connect to MySQL"
}

resource "aws_db_subnet_group" "rds" {
  name       = "subnet-group-rds"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "main" {
  identifier             = "techchallenge-mysql"
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false
}

output "rds_endpoint" {
  value = aws_db_instance.main.address
}

output "rds_port" {
  value = aws_db_instance.main.port
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_identifier" {
  value = aws_db_instance.main.identifier
}