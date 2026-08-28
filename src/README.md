# RDS infrastructure

Repositorio Terraform responsavel somente pelo MySQL e seu security group.

```powershell
terraform init
terraform apply -var db_password="<senha>"
terraform output -raw rds_endpoint
terraform output -raw rds_security_group_id
```

O backend S3 já está configurado em `main.tf`. Passe `rds_endpoint`, `rds_security_group_id` e a senha aos pipelines da Lambda e do EKS. O state contém a senha; mantenha o bucket protegido.
