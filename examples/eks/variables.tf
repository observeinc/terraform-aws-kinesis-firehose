variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  nullable    = false
  default     = "observe-eks-demo"
}

variable "cluster_version" {
  description = "EKS Cluster Version"
  type        = string
  nullable    = false
  default     = "1.21"
}


variable "observe_customer" {
  description = "Observe Customer ID"
  type        = string
}

variable "observe_token" {
  description = "Observe token"
  type        = string
}

variable "observe_domain" {
  description = "Observe Domain"
  type        = string
  default     = null
}
