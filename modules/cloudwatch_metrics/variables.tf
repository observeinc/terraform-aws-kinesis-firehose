variable "name" {
  description = "Name of Cloudwatch Metrics Stream and CloudFormation stack"
  type        = string
  default     = "observe-cwmetricsstream"
}

variable "kinesis_firehose" {
  description = "Observe Kinesis Firehose module"
  type = object({
    firehose_delivery_stream = object({ arn = string })
    firehose_iam_policy      = object({ arn = string })
  })
}

variable "iam_name_prefix" {
  description = "Prefix used for all created IAM roles and policies"
  type        = string
  default     = "observe-cwmetricsstream-"
}

variable "iam_role_arn" {
  description = "ARN of IAM role to use for Cloudwatch Metrics Stream"
  type        = string
  default     = ""
}

variable "include_filters" {
  description = "Namespaces to include. Mutually exclusive with exclude_filters."
  type        = list(string)
  default     = []
}

variable "exclude_filters" {
  description = "Namespaces to exclude. Mutually exclusive with include_filters."
  type        = list(string)
  default     = []
}
