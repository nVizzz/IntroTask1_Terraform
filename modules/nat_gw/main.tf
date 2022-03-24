resource "aws_eip" "nat-gw" {
  count = length(var.subnets_public)

  vpc = true

  tags = { Name = "eip-for-nat-gw-${count.index + 1}" }

}

resource "aws_nat_gateway" "cloudx" {
  count = length(var.subnets_public)

  allocation_id = aws_eip.nat-gw["${count.index}"].id
  subnet_id     = var.subnets_public[count.index]

  tags = { Name = "nat-gw-${count.index + 1}" }
}
