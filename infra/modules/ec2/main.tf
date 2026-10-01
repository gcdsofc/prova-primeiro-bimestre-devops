locals {
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  create_key_pair = trimspace(var.ssh_public_key) != ""
}

resource "aws_key_pair" "this" {
  count = local.create_key_pair ? 1 : 0

  key_name   = var.key_name
  public_key = var.ssh_public_key

  tags = merge(local.common_tags, {
    Name = var.key_name
  })
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  key_name               = local.create_key_pair ? aws_key_pair.this[0].key_name : null
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data

  tags = merge(local.common_tags, {
    Name = var.instance_name
  })
}