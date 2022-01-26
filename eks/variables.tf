variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe Token"
  type        = string
}

variable "observe_domain" {
  description = "Observe Domain"
  type        = string
  default     = "observeinc.com"
}

variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "pod_execution_role_arns" {
  description = "List of pod execution roles tied to Fargate profiles."
  type        = list(string)
  validation {
    condition     = try([for i in var.pod_execution_role_arns : regex("arn:aws:iam::\\d{12}:role/.+", i)], null) != null
    error_message = "ARN identifier is malformed."
  }
}
