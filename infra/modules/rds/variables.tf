variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
}

variable "db_name" {
  description = "Nome do database."
  type        = string
}

variable "db_username" {
  description = "Usuario master do banco."
  type        = string
}

variable "db_password" {
  description = "Senha master do banco."
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Subnets privadas usadas pelo RDS."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Groups associados ao RDS."
  type        = list(string)
}

variable "instance_class" {
  description = "Classe da instancia RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Armazenamento em GB."
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}