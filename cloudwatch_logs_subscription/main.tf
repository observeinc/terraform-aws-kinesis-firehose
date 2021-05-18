resource "aws_iam_role" "this" {
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
  role       = aws_iam_role.this.name
  policy_arn = var.firehose.firehose_iam_policy.arn
}

resource "aws_cloudwatch_log_subscription_filter" "subscription_filter" {
  count           = length(var.log_group_names)
  name            = var.filter_name
  log_group_name  = var.log_group_names[count.index]
  filter_pattern  = var.filter_pattern
  role_arn        = aws_iam_role.this.arn
  destination_arn = var.firehose.firehose_delivery_stream.arn
}
