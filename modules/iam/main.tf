resource "aws_iam_policy" "cloudx" {
  name        = var.name
  path        = "/"
  description = var.name

  policy = var.policy
}

resource "aws_iam_role" "cloudx" {
  name = var.name

  assume_role_policy = var.role_policy
}

resource "aws_iam_role_policy_attachment" "cloudx" {
  role       = aws_iam_role.cloudx.name
  policy_arn = aws_iam_policy.cloudx.arn
}

resource "aws_iam_instance_profile" "cloudx" {
  name = var.name
  role = aws_iam_role.cloudx.name
}
