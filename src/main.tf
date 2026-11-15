terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
  }

  backend "s3" {
    bucket       = "amz-lab-techchallenge-pt4"
    key          = "techchallenge/rds/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
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
  identifier              = "clienteveiculo-mysql"
  allocated_storage       = 10
  db_name                 = var.db_name_main
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.db_username_main
  password                = var.db_password_main
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 7
  storage_encrypted       = false
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = true
}


resource "aws_db_instance" "secondary" {
  identifier              = "ordemservico-mysql"
  allocated_storage       = 10
  db_name                 = var.db_name_sec
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  username                = var.db_username_sec
  password                = var.db_password_sec
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 7
  storage_encrypted       = false
  db_subnet_group_name    = aws_db_subnet_group.rds.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  publicly_accessible     = true
}

resource "aws_dynamodb_table" "orcamento" {
  name         = "Orcamento"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "orcamentoid"
  range_key    = "ordemservicoid"

  attribute {
    name = "orcamentoid"
    type = "S"
  }

  attribute {
    name = "ordemservicoid"
    type = "N"
  }
}

output "rds_endpoint_main" {
  value = aws_db_instance.main.address
}

output "rds_port_main" {
  value = aws_db_instance.main.port
}

output "rds_security_group_id_main" {
  value = aws_security_group.rds.id
}

output "rds_identifier_main" {
  value = aws_db_instance.main.identifier
}

output "rds_endpoint_secondary" {
  value = aws_db_instance.secondary.address
}

output "rds_port_secondary" {
  value = aws_db_instance.secondary.port
}

output "rds_security_group_id_secondary" {
  value = aws_security_group.rds.id
}

output "rds_identifier_secondary" {
  value = aws_db_instance.secondary.identifier
}

output "dynamodb_orcamento_table_name" {
  value = aws_dynamodb_table.orcamento.name
}