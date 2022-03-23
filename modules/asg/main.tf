data "terraform_remote_state" "subnet" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/subnet/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "launch_template" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/launch_template/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "lb" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/lb/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_autoscaling_group" "cloudx" {
  name                = var.name
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = toset(data.terraform_remote_state.subnet.outputs.subnets_private_ec2)

  launch_template {
    id = data.terraform_remote_state.launch_template.outputs.launch_template
  }

  lifecycle {
    ignore_changes = [
      load_balancers,
      target_group_arns
    ]
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_autoscaling_attachment" "cloudx" {
  autoscaling_group_name = aws_autoscaling_group.cloudx.id
  lb_target_group_arn    = data.terraform_remote_state.lb.outputs.lb_target_group_arn
}
