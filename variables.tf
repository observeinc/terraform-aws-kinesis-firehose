variable "name" {
  description = "Name of Kinesis Firehose resource"
  type        = string
}

variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe Token"
  type        = string

  validation {
    condition     = contains(split("", var.observe_token), ":")
    error_message = "Token format does not follow {datastream_id}:{datastream_secret} format."
  }
}

variable "observe_domain" {
  description = "Observe domain"
  type        = string
  nullable    = false
  default     = "observeinc.com"
}

variable "s3_delivery_bucket" {
  description = "S3 bucket to be used as backup for message delivery"
  type = object({
    arn = string
  })
  default = null
}

# Optional input variables
variable "observe_url" {
  description = "Observe URL. Deprecated."
  type        = string
  nullable    = false
  default     = ""
}

variable "http_endpoint_name" {
  description = "Name of Kinesis Firehose target HTTP endpoint"
  type        = string
  nullable    = false
  default     = "Observe"
}

variable "http_endpoint_s3_backup_mode" {
  description = "S3 backup mode for Kinesis Firehose HTTP endpoint"
  type        = string
  nullable    = false
  # alternative is "AllData"
  default = "FailedDataOnly"
}

variable "http_endpoint_buffering_interval" {
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination."
  type        = number
  nullable    = false
  default     = 60
}

variable "http_endpoint_buffering_size" {
  description = "Buffer incoming data to the specified size, in MiBs, before delivering it to the destination."
  type        = number
  nullable    = false
  default     = 1
}

variable "http_endpoint_retry_duration" {
  description = "The total amount of time that Kinesis Data Firehose spends on retries. This duration starts after the initial attempt to send data to the custom destination via HTTPS endpoint fails. It doesn't include the periods during which Kinesis Data Firehose waits for acknowledgment from the specified destination after each attempt."
  type        = number
  nullable    = false
  default     = 300
}

variable "http_endpoint_content_encoding" {
  description = "Kinesis Data Firehose uses the content encoding to compress the body of a request before sending the request to the destination."
  type        = string
  nullable    = false
  default     = "GZIP"
}

variable "s3_delivery_buffer_interval" {
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination."
  type        = number
  nullable    = false
  default     = 300
}

variable "s3_delivery_buffer_size" {
  description = "Buffer incoming data to the specified size, in MiBs, before delivering it to the destination."
  type        = number
  nullable    = false
  default     = 5
}

variable "s3_delivery_compression_format" {
  description = "The compression format. If no value is specified, the default is UNCOMPRESSED."
  type        = string
  nullable    = false
  default     = "UNCOMPRESSED"
}

variable "s3_delivery_prefix" {
  description = "The \"YYYY/MM/DD/HH\" time format prefix is automatically used for delivered Amazon S3 files"
  type        = string
  default     = null
}

variable "cloudwatch_log_group" {
  description = "The CloudWatch group for logging. Providing this value enables logging."
  type = object({
    name = string
    arn  = string
  })
  default = null
}

variable "s3_delivery_cloudwatch_log_stream_name" {
  description = "Log stream name for S3 delivery logs. If empty, log stream will be disabled"
  type        = string
  nullable    = false
  default     = "S3Delivery"
}

variable "http_endpoint_cloudwatch_log_stream_name" {
  description = "Log stream name for HTTP endpoint logs. If empty, log stream will be disabled"
  type        = string
  nullable    = false
  default     = "HttpEndpointDelivery"
}

variable "iam_name_prefix" {
  description = "Prefix used for all created IAM roles and policies"
  type        = string
  nullable    = false
  default     = "observe-kinesis-firehose-"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  nullable    = false
  default     = {}
}

variable "kinesis_stream" {
  description = "Kinesis Data Stream ARN to configure as source"
  type        = object({ arn = string })
  default     = null
}

variable "common_attributes" {
  description = "Key value pairs sent as payload metadata"
  type        = map(string)
  nullable    = false
  default     = {}
}
