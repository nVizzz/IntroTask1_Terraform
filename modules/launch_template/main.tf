data "terraform_remote_state" "iam" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/iam/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "key_pair" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/key_pair/terraform.tfstate"
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

resource "aws_launch_template" "cloudx" {
  name = var.name

  iam_instance_profile {
    name = data.terraform_remote_state.iam.outputs.instance_profile
  }

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  instance_type                        = var.instance_type
  key_name                             = data.terraform_remote_state.key_pair.outputs.key_pair

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    security_groups             = [data.terraform_remote_state.sg.outputs.sg_private]
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.common_tags, { Name = "${var.name}" })
  }

  user_data = var.user_data_base64
}
