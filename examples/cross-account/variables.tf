variable "observe_collection_endpoint" {
  description = "Observe Collection Endpoint, e.g https://123456789012.collect.observeinc.com"
  type        = string
}

variable "observe_token" {
  description = "Observe token"
  type        = string
}

variable "name" {
  type        = string
  description = "Name for firehose and matching IAM role"
}

variable "http_endpoint_s3_backup_mode" {
  type        = string
  description = "S3 backup mode for Kinesis Firehose HTTP endpoint. By default, only data that cannot be delivered to Observe via HTTP is written to S3. To backup all data to S3, set this to `AllData`."
  nullable    = false
  default     = "FailedDataOnly"
}

variable "s3_delivery_compression_format" {
  description = "The compression format. If no value is specified, the default is UNCOMPRESSED."
  type        = string
  nullable    = false
  default     = "UNCOMPRESSED"
}

variable "s3_delivery_data_retention" {
  description = "Days to retain files in S3."
  type        = number
  nullable    = false
  default     = 30
}

variable "user_arn" {
  type        = string
  description = "ARN for external user granted access to assume role"
  validation {
    condition     = try(regex("arn:aws:iam::\\d{12}:user/.+", var.user_arn), null) != null
    error_message = "ARN identifier is malformed."
  }
}

variable "external_ids" {
  type        = list(string)
  description = "External ID array"
  default     = null
}
