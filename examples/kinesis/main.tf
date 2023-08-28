provider "aws" {
  region = "us-west-1"
}

resource "random_pet" "run" {}

module "observe_kinesis" {
  source = "../.."

  observe_collection_endpoint = var.observe_collection_endpoint
  observe_token               = var.observe_token

  name           = random_pet.run.id
  kinesis_stream = aws_kinesis_stream.this
}
