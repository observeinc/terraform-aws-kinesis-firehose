variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe token"
  type        = string
}

variable "observe_url" {
  description = "Observe URL"
  type        = string
  default     = "https://kinesis.collect.observeinc.com"
}
