

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0c04f9d3f5e86ae50"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-02cd6e93afd15dae9","subnet-02fb07eb66ab63955"]
}

variable "client_security_group_id" {
  type    = string
  default = "sg-0c106ea4e88e62e3b"
}

variable "db_name_main" {
  type    = string
  default = "OsItemEstoque"
}

variable "db_username_main" {
  type    = string
  default = "root"
}

variable "db_password_main" {
  type    = string
  default = "minha-senha"
}

variable "db_name_sec" {
  type    = string
  default = "ClienteVeiculo"
}

variable "db_username_sec" {
  type    = string
  default = "root"
}

variable "db_password_sec" {
  type    = string
  default = "minha-senha"
}