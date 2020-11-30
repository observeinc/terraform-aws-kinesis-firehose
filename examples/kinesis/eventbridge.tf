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

resource "aws_iam_role_policy_attachment" "eventbridge_kinesis" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.put_stream.arn
}

resource "aws_cloudwatch_event_target" "target" {
  rule     = aws_cloudwatch_event_rule.scheduled.name
  arn      = aws_kinesis_stream.this.arn
  role_arn = aws_iam_role.role.arn
}
