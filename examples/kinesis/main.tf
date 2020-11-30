provider "aws" {
  region = "us-west-1"
}

resource "random_pet" "run" {}

resource "aws_s3_bucket" "bucket" {
  bucket        = random_pet.run.id
  acl           = "private"
  force_destroy = true
}

module "observe_kinesis" {
  source           = "../.."
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_url      = var.observe_url

  name               = random_pet.run.id
  kinesis_stream     = aws_kinesis_stream.this
  s3_delivery_bucket = aws_s3_bucket.bucket
}
