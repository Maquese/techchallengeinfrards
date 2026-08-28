terraform {
  backend "s3" {
    key          = "rds/terraform.tfstate"
    encrypt      = true
    use_lockfile = true
  }
}