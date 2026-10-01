output "ec2_public_ip" {
  description = "IP publico da EC2 que roda a API."
  value       = module.api.public_ip
}

output "api_url" {
  description = "URL publica da API de Reservas."
  value       = "http://${module.api.public_ip}:3000"
}

output "rds_endpoint" {
  description = "Endpoint do RDS PostgreSQL."
  value       = module.database.db_endpoint
}

output "rds_address" {
  description = "Endereco DNS do RDS PostgreSQL."
  value       = module.database.db_address
}