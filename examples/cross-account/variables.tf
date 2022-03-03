variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe token"
  type        = string
}

variable "observe_domain" {
  description = "Observe domain"
  type        = string
  default     = "observeinc.com"
}

variable "name" {
  type        = string
  description = "Name for firehose and matching IAM role"
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
