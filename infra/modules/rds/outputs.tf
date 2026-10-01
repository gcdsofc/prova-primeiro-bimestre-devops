output "db_endpoint" {
  description = "Endpoint completo do RDS."
  value       = aws_db_instance.this.endpoint
}

output "db_address" {
  description = "Endereco DNS do RDS."
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "Porta do RDS."
  value       = aws_db_instance.this.port
}