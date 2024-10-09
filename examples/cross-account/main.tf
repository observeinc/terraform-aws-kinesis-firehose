locals {
  external_account_id = regex("arn:aws:iam::(?P<account_id>\\d{12}):user/.+$", var.user_arn)["account_id"]
}

resource "aws_cloudwatch_log_group" "group" {
  name              = format("/observe/kinesisfirehose/%s", var.name)
  retention_in_days = 14
}

module "observe_kinesis_firehose" {
  source = "../.."

  observe_collection_endpoint = var.observe_collection_endpoint
  observe_token               = var.observe_token

  name                 = var.name
  cloudwatch_log_group = aws_cloudwatch_log_group.group

  http_endpoint_s3_backup_mode = var.http_endpoint_s3_backup_mode
}

resource "aws_iam_role" "this" {
  name               = var.name
  description        = "Cross account role for matching firehose delivery stream"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [local.external_account_id]
    }

    dynamic "condition" {
      for_each = var.external_ids != null ? [1] : []
      content {
        test     = "StringEquals"
        variable = "sts:ExternalId"
        values   = var.external_ids
      }
    }
  }
}

resource "aws_iam_policy" "put_record" {
  name_prefix = var.name
  policy      = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": [
                "${module.observe_kinesis_firehose.firehose_delivery_stream.arn}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole"
            ],
            "Resource": [
                "${var.user_arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.put_record.arn
}
