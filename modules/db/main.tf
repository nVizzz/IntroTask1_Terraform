data "terraform_remote_state" "subnet" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_db_subnet_group" "cloudx" {
  name       = var.name
  subnet_ids = toset(data.terraform_remote_state.subnet.outputs.subnets_private_db)
}

resource "aws_db_instance" "cloudx" {
  availability_zone       = data.terraform_remote_state.subnet.outputs.availability_zones[0]
  allocated_storage       = var.allocated_storage
  backup_retention_period = var.backup_retention_period
  db_name                 = var.name
  db_subnet_group_name    = aws_db_subnet_group.cloudx.name
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  multi_az                = var.multi_az
  username                = var.username
  password                = var.db_password
  parameter_group_name    = var.parameter_group_name
  skip_final_snapshot     = var.skip_final_snapshot
  storage_type            = var.storage_type
  vpc_security_group_ids  = [data.terraform_remote_state.sg.outputs.sg_private_db]
}

resource "aws_db_instance" "cloudx_replica" {
  count = var.azs - 1

  availability_zone      = data.terraform_remote_state.subnet.outputs.availability_zones[count.index + 1]
  allocated_storage      = var.allocated_storage
  instance_class         = var.instance_class
  parameter_group_name   = var.parameter_group_name
  replicate_source_db    = aws_db_instance.cloudx.id
  skip_final_snapshot    = var.skip_final_snapshot
  storage_type           = var.storage_type
  vpc_security_group_ids = [data.terraform_remote_state.sg.outputs.sg_private_db]

  tags = { Name = "${var.name}-replica-${count.index + 1}" }
}
