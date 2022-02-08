terraform {
  required_version = ">= 0.13"

  required_providers {
    aws        = ">= 3.15"
    kubernetes = ">= 2.0"
    random     = ">= 3.0.0"
  }
}