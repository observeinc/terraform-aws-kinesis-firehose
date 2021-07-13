resource "aws_cloudwatch_event_rule" "scheduled" {
  name                = "tf-scheduled-event"
  schedule_expression = "rate(1 minute)"
  event_bus_name      = "default"
}


module "observe_eventbridge_kinesis" {
  source           = "../../eventbridge"
  kinesis_firehose = module.observe_kinesis_firehose
  rules = [
    aws_cloudwatch_event_rule.scheduled,
  ]
}
