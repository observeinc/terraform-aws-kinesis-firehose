variable "observe_collection_endpoint" {
  description = "Observe Collection Endpoint, e.g https://123456789012.collect.observeinc.com"
  type        = string
  default     = null
}

variable "observe_customer" {
  description = "Observe Customer ID. Deprecated, please use observe_collection_endpoint instead"
  type        = string
  default     = null
}

variable "observe_token" {
  description = "Observe Token"
  type        = string
}

variable "observe_domain" {
  description = "Observe domain. Deprecated, please use observe_collection_endpoint instead"
  type        = string
  default     = null
}

variable "eks_cluster_arn" {
  description = "EKS cluster ARN"
  type        = string
  validation {
    condition     = try(regex("arn:aws:eks:[^:]+:\\d{12}:cluster/.+", var.eks_cluster_arn), null) != null
    error_message = "ARN identifier is malformed."
  }
}

variable "pod_execution_role_arns" {
  description = "List of pod execution roles tied to Fargate profiles."
  type        = list(string)
  validation {
    condition     = try([for i in var.pod_execution_role_arns : regex("arn:aws:iam::\\d{12}:role/.+", i)], null) != null
    error_message = "ARN identifier is malformed."
  }
}
