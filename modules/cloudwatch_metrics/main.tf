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
        "Service": "streams.metrics.cloudwatch.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "firehose" {
  role       = local.iam_role_name
  policy_arn = var.kinesis_firehose.firehose_iam_policy.arn
}

resource "aws_cloudwatch_metric_stream" "main" {
  name          = var.name
  role_arn      = local.iam_role_arn
  firehose_arn  = var.kinesis_firehose.firehose_delivery_stream.arn
  output_format = "json"

  dynamic "include_filter" {
    for_each = var.include_filters
    content {
      namespace = include_filter.value
    }
  }

  dynamic "exclude_filter" {
    for_each = var.exclude_filters
    content {
      namespace = exclude_filter.value
    }
  }
}
