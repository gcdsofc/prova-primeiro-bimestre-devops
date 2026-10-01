locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project   = "prova-primeiro-bimestre-devops"
    Owner     = var.owner_ra
    ManagedBy = "Terraform"
    Aula      = "03-06"
  }

  subnets = {
    public-1  = { cidr = "10.20.1.0/24", az = "us-east-1a", type = "public" }
    public-2  = { cidr = "10.20.2.0/24", az = "us-east-1b", type = "public" }
    private-1 = { cidr = "10.20.11.0/24", az = "us-east-1a", type = "private" }
    private-2 = { cidr = "10.20.12.0/24", az = "us-east-1b", type = "private" }
  }

  database_url = "postgres://${var.db_username}:${var.db_password}@${module.database.db_address}:${module.database.db_port}/${var.db_name}"
}