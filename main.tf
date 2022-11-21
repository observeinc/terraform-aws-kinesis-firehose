locals {
  enable_cloudwatch            = var.cloudwatch_log_group != null
  enable_s3_logging            = local.enable_cloudwatch && var.s3_delivery_cloudwatch_log_stream_name != ""
  enable_http_endpoint_logging = local.enable_cloudwatch && var.http_endpoint_cloudwatch_log_stream_name != ""
  enable_kinesis_source        = var.kinesis_stream != null
  access_key                   = var.observe_token
  create_s3_bucket             = var.s3_delivery_bucket == null
  s3_bucket_arn                = local.create_s3_bucket ? aws_s3_bucket.bucket[0].arn : var.s3_delivery_bucket.arn
  observe_url                  = var.observe_url != "" ? var.observe_url : format("https://%s.collect.%s/v1/kinesis", var.observe_customer, var.observe_domain)
}

resource "random_string" "bucket_suffix" {
  count   = local.create_s3_bucket ? 1 : 0
  length  = 8
  upper   = false
  special = false
}

resource "aws_s3_bucket" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket        = format("%s-%s", var.name, random_string.bucket_suffix[0].result)
  force_destroy = true
}

resource "aws_s3_bucket_acl" "bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = aws_s3_bucket.bucket[0].id
  acl    = "private"
}

resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.name
  destination = "http_endpoint"

  s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = local.s3_bucket_arn

    buffer_size        = var.s3_delivery_buffer_size
    buffer_interval    = var.s3_delivery_buffer_interval
    compression_format = var.s3_delivery_compression_format
    prefix             = var.s3_delivery_prefix
    # kms_key_arn

    cloudwatch_logging_options {
      enabled         = local.enable_s3_logging
      log_group_name  = local.enable_s3_logging ? var.cloudwatch_log_group.name : ""
      log_stream_name = local.enable_s3_logging ? var.s3_delivery_cloudwatch_log_stream_name : ""
    }
  }

  dynamic "kinesis_source_configuration" {
    for_each = local.enable_kinesis_source ? [1] : []
    content {
      kinesis_stream_arn = var.kinesis_stream.arn
      role_arn           = aws_iam_role.firehose.arn
    }
  }

  http_endpoint_configuration {
    url            = local.observe_url
    name           = var.http_endpoint_name
    access_key     = local.access_key
    role_arn       = aws_iam_role.firehose.arn
    s3_backup_mode = var.http_endpoint_s3_backup_mode

    retry_duration     = var.http_endpoint_retry_duration
    buffering_size     = var.http_endpoint_buffering_size
    buffering_interval = var.http_endpoint_buffering_interval

    request_configuration {
      content_encoding = var.http_endpoint_content_encoding
      dynamic "common_attributes" {
        for_each = var.common_attributes
        content {
          name  = common_attributes.key
          value = common_attributes.value
        }
      }
    }

    cloudwatch_logging_options {
      enabled         = local.enable_http_endpoint_logging
      log_group_name  = local.enable_http_endpoint_logging ? var.cloudwatch_log_group.name : ""
      log_stream_name = local.enable_http_endpoint_logging ? var.http_endpoint_cloudwatch_log_stream_name : ""
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "firehose" {
  name_prefix        = var.iam_name_prefix
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "firehose_s3" {
  name_prefix = var.iam_name_prefix
  policy      = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "s3:AbortMultipartUpload",
            "s3:GetBucketLocation",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:ListBucketMultipartUploads",
            "s3:PutObject"
        ],
        "Resource": [
            "${local.s3_bucket_arn}",
            "${local.s3_bucket_arn}/*"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "firehose_s3" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose_s3.arn
}

resource "aws_iam_policy" "put_record" {
  name_prefix = var.iam_name_prefix
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
                "${aws_kinesis_firehose_delivery_stream.this.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_cloudwatch_log_stream" "http_endpoint_delivery" {
  count          = local.enable_http_endpoint_logging ? 1 : 0
  name           = var.http_endpoint_cloudwatch_log_stream_name
  log_group_name = var.cloudwatch_log_group.name
}

resource "aws_cloudwatch_log_stream" "s3_delivery" {
  count          = local.enable_s3_logging ? 1 : 0
  name           = var.s3_delivery_cloudwatch_log_stream_name
  log_group_name = var.cloudwatch_log_group.name
}

resource "aws_iam_policy" "firehose_cloudwatch" {
  name_prefix = var.iam_name_prefix
  count       = local.enable_cloudwatch ? 1 : 0

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
        ],
        "Resource": [
            "${var.cloudwatch_log_group.arn}"
        ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "firehose_cloudwatch" {
  count = local.enable_cloudwatch ? 1 : 0

  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose_cloudwatch[0].arn
}

resource "aws_iam_policy" "kinesis_firehose" {
  name_prefix = var.iam_name_prefix
  count       = local.enable_kinesis_source ? 1 : 0

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Sid": "",
        "Effect": "Allow",
        "Action": [
            "kinesis:DescribeStream",
            "kinesis:GetShardIterator",
            "kinesis:GetRecords",
            "kinesis:ListShards"
        ],
        "Resource": "${var.kinesis_stream.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "kinesis_firehose" {
  count = local.enable_kinesis_source ? 1 : 0

  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.kinesis_firehose[0].arn
}
