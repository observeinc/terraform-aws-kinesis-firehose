resource "aws_cloudwatch_event_rule" "scheduled" {
  name                = "tf-scheduled-event"
  schedule_expression = "rate(1 minute)"
  event_bus_name      = "default"
}

resource "aws_iam_role" "role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "invoke_firehose" {
  role       = aws_iam_role.role.name
  policy_arn = module.observe_kinesis.firehose_iam_policy.arn
}

resource "aws_cloudwatch_event_target" "target" {
  rule     = aws_cloudwatch_event_rule.scheduled.name
  arn      = module.observe_kinesis.firehose_delivery_stream.arn
  role_arn = aws_iam_role.role.arn
}
