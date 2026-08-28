

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0b8ea6480aff3581d"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-01799be41421baa8d", "subnet-0d850838bbd1a4e72", "subnet-0a6b760a3d564676b"]
}

variable "client_security_group_id" {
  type    = string
  default = "sg-0471a65dcdc5a7dd5"
}

variable "db_name" {
  type    = string
  default = "Tests"
}

variable "db_username" {
  type    = string
  default = "root"
}

variable "db_password" {
  type      = string
  sensitive = true
}