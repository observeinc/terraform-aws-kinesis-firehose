variable "name" {
  description = "Name of Cloudwatch Metrics Stream and CloudFormation stack"
  type        = string
  nullable    = false
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
  nullable    = false
  default     = "observe-cwmetricsstream-"
}

variable "iam_role_arn" {
  description = "ARN of IAM role to use for Cloudwatch Metrics Stream"
  type        = string
  nullable    = false
  default     = ""
}

variable "include_filters" {
  description = "Namespaces to include. Mutually exclusive with exclude_filters."
  type        = set(string)
  nullable    = false
  default     = []
}

variable "exclude_filters" {
  description = "Namespaces to exclude. Mutually exclusive with include_filters."
  type        = set(string)
  nullable    = false
  default     = []
}

variable "statistics_configurations" {
  description = "A list of additional statistics configurations to include."
  type = list(object({
    additional_statistics = list(string)
    include_metrics = list(object({
      namespace   = string
      metric_name = string
    }))
  }))
  default = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "output_format" {
  description = "Output format for the stream"
  type        = string
  nullable    = false
  default     = "json"
}
