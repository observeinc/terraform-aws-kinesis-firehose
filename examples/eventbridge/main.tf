provider "aws" {
  region = "us-west-1"
}

resource "random_pet" "run" {}

resource "aws_s3_bucket" "bucket" {
  bucket        = random_pet.run.id
  acl           = "private"
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "group" {
  name              = format("/observe/kinesisfirehose/%s", random_pet.run.id)
  retention_in_days = 14
}

module "observe_kinesis" {
  source           = "../.."
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_url      = var.observe_url

  name                 = random_pet.run.id
  s3_delivery_bucket   = aws_s3_bucket.bucket
  cloudwatch_log_group = aws_cloudwatch_log_group.group
}