variable "aws_region" {
  description = "Regiao fixa do AWS Academy Learner Lab."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome base dos recursos."
  type        = string
  default     = "reservas"
}

variable "environment" {
  description = "Ambiente."
  type        = string
  default     = "academy"
}

variable "owner_ra" {
  description = "RA do aluno."
  type        = string
  default     = "6325300"
}

variable "vpc_cidr" {
  description = "CIDR da VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "allowed_ssh_cidr" {
  description = "CIDR autorizado para SSH na EC2. Restrinja ao seu IP no laboratorio."
  type        = string
  default     = "203.0.113.10/32"
}

variable "ami_id" {
  description = "AMI Amazon Linux 2023 em us-east-1."
  type        = string
  default     = "ami-0c101f26f147fa7fd"
}

variable "ssh_public_key" {
  description = "Chave publica SSH opcional. Deixe vazio se nao for acessar por SSH."
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_name" {
  description = "Nome do database da API."
  type        = string
  default     = "reservas_db"
}

variable "db_username" {
  description = "Usuario master do RDS."
  type        = string
  default     = "reservas_user"
}

variable "db_password" {
  description = "Senha master do RDS. Informe via terraform.tfvars local ou TF_VAR_db_password."
  type        = string
  sensitive   = true
}

variable "use_lab_instance_profile" {
  description = "Usa LabInstanceProfile no AWS Academy quando true."
  type        = bool
  default     = true
}

variable "lab_instance_profile_name" {
  description = "Instance profile pre-existente no AWS Academy."
  type        = string
  default     = "LabInstanceProfile"
}