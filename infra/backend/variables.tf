variable "aws_region" {
  description = "Regiao AWS usada no AWS Academy Learner Lab."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nome base do projeto."
  type        = string
  default     = "reservas"
}

variable "owner_ra" {
  description = "RA do aluno usado para nomes unicos."
  type        = string
  default     = "6325300"
}