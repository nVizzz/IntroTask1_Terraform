data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "subnet" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "igw" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/igw/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "nat_gw" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/nat_gw/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_route_table" "private_rt" {
  count = length(data.terraform_remote_state.subnet.outputs.availability_zones)

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = { Name = "RT-Private-${data.terraform_remote_state.subnet.outputs.availability_zones[count.index]}" }
}

resource "aws_route" "route_public" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = var.cidr_block
  gateway_id             = data.terraform_remote_state.igw.outputs.igw_id
}

resource "aws_route" "route_private" {
  count = length(data.terraform_remote_state.subnet.outputs.availability_zones)

  route_table_id         = aws_route_table.private_rt[count.index].id
  destination_cidr_block = var.cidr_block
  gateway_id             = data.terraform_remote_state.nat_gw.outputs.nat_gw[count.index]
}

resource "aws_route_table_association" "public" {
  count = length(var.subnets_public)

  subnet_id      = data.terraform_remote_state.subnet.outputs.subnets_public[count.index]
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = data.terraform_remote_state.subnet.outputs.subnets_private[count.index]
  route_table_id = aws_route_table.private_rt[count.index].id
}
