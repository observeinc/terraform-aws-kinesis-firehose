locals {
  iam_role_arn  = var.iam_role_arn != "" ? var.iam_role_arn : aws_iam_role.this[0].arn
  iam_role_name = regex(".*role/(?P<role_name>.*)$", local.iam_role_arn)["role_name"]
}

resource "aws_iam_role" "this" {
  count              = var.iam_role_arn == "" ? 1 : 0
  name_prefix        = var.iam_name_prefix
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "logs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = local.iam_role_name
  policy_arn = var.kinesis_firehose.firehose_iam_policy.arn
}

resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  count           = length(var.log_group_names)
  name            = var.filter_name
  log_group_name  = var.log_group_names[count.index]
  filter_pattern  = var.filter_pattern
  role_arn        = local.iam_role_arn
  destination_arn = var.kinesis_firehose.firehose_delivery_stream.arn
}
