# RDS infrastructure

Repositorio Terraform responsavel somente pelo MySQL e seu security group.

```powershell
terraform init -backend-config="bucket=<bucket-do-state>" -backend-config="region=us-east-1"
terraform plan -var db_password="<senha>" -out=tfplan
terraform apply tfplan
terraform output -raw rds_endpoint
terraform output -raw rds_security_group_id
```

O workflow `.github/workflows/deploy-aws.yml` executa `plan` e `apply` no self-runner para pushes em `main`/`master` e para `workflow_dispatch`. Configure no GitHub:

- Variable `TF_STATE_BUCKET`: bucket S3 existente, privado e versionado para o state.
- Variable `AWS_REGION`: opcional; usa `us-east-1` por padrão.
- Secret `TF_VAR_RDS_PASSWORD`: senha do RDS.
- Environment `production`: adicione aprovação manual e restrinja-o às branches protegidas.

O bucket do backend precisa existir antes do primeiro `terraform init`. O self-runner deve autenticar na AWS com uma role de menor privilégio. Para produção, habilite `deletion_protection` e snapshot final no RDS. O state remoto continua contendo a senha, portanto o bucket deve ter criptografia, versionamento e acesso restrito.
