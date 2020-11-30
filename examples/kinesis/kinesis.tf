resource "aws_kinesis_stream" "this" {
  name             = "terraform-kinesis-test"
  shard_count      = 1
  retention_period = 24
}

resource "aws_iam_policy" "put_stream" {
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:PutRecord",
                "kinesis:PutRecords"
            ],
            "Resource": "${aws_kinesis_stream.this.arn}"
        }
    ]
}
EOF
}
