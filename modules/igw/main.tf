data "terraform_remote_state" "s3" {
  backend = "s3"
  config = {
    bucket = "introtask1-terragrunt-nvizzz"
    key = "dev/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_internet_gateway" "cloudx" {
  vpc_id = data.terraform_remote_state.s3.outputs.vpc_id
}
