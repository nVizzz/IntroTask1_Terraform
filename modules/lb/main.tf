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

data "terraform_remote_state" "sg" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/sg/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_lb" "cloudx" {
  name               = var.name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [data.terraform_remote_state.sg.outputs.sg_public]

  dynamic "subnet_mapping" {
    for_each = toset(data.terraform_remote_state.subnet.outputs.subnets_public)
    content {
      subnet_id = subnet_mapping.value
    }
  }

  enable_deletion_protection = var.enable_deletion_protection
}

resource "aws_lb_listener" "cloudx" {
  load_balancer_arn = aws_lb.cloudx.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.cloudx.arn
      }
    }
  }
}

resource "aws_lb_target_group" "cloudx" {
  name     = var.name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id
}
