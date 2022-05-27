data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type = "Service"
    }
  }
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:ModifyInstanceAttribute",
      "ec2:CreateRoute",
      "ec2:ReplaceRoute"
    ]
    effect = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role" "main" {
  count = local.create_nat ? 1 : 0
  
  name = "${var.prefix}_nat_instance_role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_nat_instance_role"
    }
  )
}

resource "aws_iam_role_policy" "main" {
  count = local.create_nat ? 1 : 0

  name = "${var.prefix}_nat_instance_role_policy"

  policy = data.aws_iam_policy_document.role_policy.json
  role = aws_iam_role.main[0].name
}

resource "aws_iam_instance_profile" "main" {
  count = local.create_nat ? 1 : 0
  
  name = "${var.prefix}_nat_instance_prof"

  role = aws_iam_role.main[0].name

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}_nat_instance_prof"
    }
  )
}
