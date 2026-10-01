output "vpc_id" {
  description = "ID da VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs das subnets publicas."
  value       = [for name in sort(keys(local.public_subnets)) : aws_subnet.this[name].id]
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas."
  value       = [for name in sort(keys(local.private_subnets)) : aws_subnet.this[name].id]
}