variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Nome do ambiente."
  type        = string
}

variable "instance_name" {
  description = "Nome da instancia EC2."
  type        = string
}

variable "ami_id" {
  description = "AMI usada pela EC2."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instancia EC2."
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet onde a EC2 sera criada."
  type        = string
}

variable "security_group_ids" {
  description = "Security Groups associados a EC2."
  type        = list(string)
}

variable "ssh_public_key" {
  description = "Chave publica SSH opcional."
  type        = string
  default     = ""
  sensitive   = true
}

variable "key_name" {
  description = "Nome do key pair opcional."
  type        = string
  default     = ""
}

variable "iam_instance_profile" {
  description = "Instance profile pre-existente, como LabInstanceProfile."
  type        = string
  default     = null
}

variable "user_data" {
  description = "Script de inicializacao da instancia."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags adicionais."
  type        = map(string)
  default     = {}
}