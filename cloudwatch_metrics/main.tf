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

resource "aws_cloudformation_stack" "this" {
  name       = var.name
  parameters = {}

  template_body = yamlencode({
    AWSTemplateFormatVersion = "2010-09-09"
    Description              = "Subscribe Cloudwatch Metric Streams to Observe Kinesis Firehose",
    Resources = {
      MetricStream = {
        Type = "AWS::CloudWatch::MetricStream",
        Properties = merge({
          Name         = var.name
          FirehoseArn  = var.kinesis_firehose.firehose_delivery_stream.arn
          RoleArn      = local.iam_role_arn
          OutputFormat = "json"
          }, length(var.exclude_filters) == 0 ? {} : {
          ExcludeFilters = [for i in var.exclude_filters : { "Namespace" = i }]
          }, length(var.include_filters) == 0 ? {} : {
          IncludeFilters = [for i in var.include_filters : { "Namespace" = i }]
        })
      }
    }
  })
}
