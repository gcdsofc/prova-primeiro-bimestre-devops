module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
  subnets      = local.subnets
  tags         = local.common_tags
}

module "ec2_sg" {
  source = "./modules/security-group"

  name         = "${local.name_prefix}-ec2-sg"
  description  = "Acesso minimo para EC2 da API de Reservas"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags

  ingress_rules = [
    {
      description = "SSH"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.allowed_ssh_cidr]
    },
    {
      description = "API Reservas"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

module "rds_sg" {
  source = "./modules/security-group"

  name         = "${local.name_prefix}-rds-sg"
  description  = "Acesso PostgreSQL apenas da EC2 da API"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  environment  = var.environment
  tags         = local.common_tags

  ingress_rules = [
    {
      description        = "PostgreSQL from EC2 SG"
      from_port          = 5432
      to_port            = 5432
      protocol           = "tcp"
      security_group_ids = [module.ec2_sg.sg_id]
    }
  ]
}

module "database" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = var.environment
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = var.db_password
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.rds_sg.sg_id]
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  tags               = local.common_tags
}

module "api" {
  source = "./modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  instance_name        = "${local.name_prefix}-api"
  ami_id               = var.ami_id
  instance_type        = "t2.micro"
  subnet_id            = module.vpc.public_subnet_ids[0]
  security_group_ids   = [module.ec2_sg.sg_id]
  ssh_public_key       = var.ssh_public_key
  key_name             = "${local.name_prefix}-key"
  iam_instance_profile = var.use_lab_instance_profile ? var.lab_instance_profile_name : null
  user_data            = templatefile("${path.module}/user_data.sh.tftpl", { database_url = local.database_url })
  tags                 = local.common_tags
}