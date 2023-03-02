terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws        = ">= 3.15, < 4.0"
    kubernetes = ">= 2.0"
    random     = ">= 3.0.0"
  }
}
