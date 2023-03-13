variable "kinesis_firehose" {
  description = "Observe Kinesis Firehose module"
  type = object({
    firehose_delivery_stream = object({ arn = string })
    firehose_iam_policy      = object({ arn = string })
  })
}

variable "log_group_names" {
  description = "Cloudwatch Log Group names to subscribe to Observe Lambda"
  type        = list(string)
}

variable "filter_pattern" {
  description = "The filter pattern to use. For more information, see [Filter and Pattern Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html)"
  type        = string
  nullable    = false
  default     = ""
}

variable "filter_name" {
  description = "Filter name"
  type        = string
  nullable    = false
  default     = "observe-filter"
}

variable "iam_name_prefix" {
  description = "Prefix used for all created IAM roles and policies"
  type        = string
  nullable    = false
  default     = "observe-kinesis-firehose-"
}

variable "iam_role_arn" {
  description = "ARN of IAM role to use for Cloudwatch Logs subscription"
  type        = string
  nullable    = false
  default     = ""
}
