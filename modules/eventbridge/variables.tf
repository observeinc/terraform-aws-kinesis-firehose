variable "iam_name_prefix" {
  description = "Prefix used for all created IAM roles and policies"
  type        = string
  default     = "observe-kinesis-firehose-"
}

variable "kinesis_firehose" {
  description = "Observe Kinesis Firehose module"
  type = object({
    firehose_delivery_stream = object({ arn = string })
    firehose_iam_policy      = object({ arn = string })
  })
}

variable "iam_role_arn" {
  description = "ARN of IAM role to use for EventBridge target"
  type        = string
  default     = ""
}

variable "rules" {
  description = "List of EventBridge rules to subscribe to Firehose"
  type        = list(object({ name = string }))
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
