output "state_bucket_name" {
  description = "Nome do bucket S3 usado para remote state."
  value       = aws_s3_bucket.terraform_state.bucket
}

output "lock_table_name" {
  description = "Nome da tabela DynamoDB usada para state locking."
  value       = aws_dynamodb_table.terraform_locks.name
}

output "backend_config" {
  description = "Configuracao usada pelo backend S3 do ambiente AWS Academy."
  value = {
    bucket         = aws_s3_bucket.terraform_state.bucket
    key            = "aws-academy/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = aws_dynamodb_table.terraform_locks.name
    encrypt        = true
  }
}