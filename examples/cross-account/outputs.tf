output "firehose_arn" {
  value       = module.observe_kinesis_firehose.firehose_delivery_stream.arn
  description = "Configured firehose"
}

output "cross_account_role" {
  value       = aws_iam_role.this.arn
  description = "Role providing cross-account access to provided user"
}
