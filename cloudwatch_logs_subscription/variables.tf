variable "firehose" {
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
  default     = ""
}

variable "filter_name" {
  description = "Filter name"
  type        = string
  default     = "observe-filter"
}
