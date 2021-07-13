provider "aws" {
  region = "us-west-1"
}

resource "random_pet" "run" {}

resource "aws_cloudwatch_log_group" "group" {
  name              = format("/observe/kinesisfirehose/%s", random_pet.run.id)
  retention_in_days = 14
}

module "observe_kinesis_firehose" {
  source           = "../.."
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_url      = var.observe_url

  name                 = random_pet.run.id
  cloudwatch_log_group = aws_cloudwatch_log_group.group
}
