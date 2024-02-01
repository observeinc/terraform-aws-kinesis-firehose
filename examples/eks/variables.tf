variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = null
}

variable "cluster_version" {
  description = "EKS Cluster Version"
  type        = string
  nullable    = false
  default     = "1.27"
}

variable "observe_collection_endpoint" {
  description = "Observe Collection Endpoint, e.g https://123456789012.collect.observeinc.com"
  type        = string
}

variable "observe_token" {
  description = "Observe token"
  type        = string
}
