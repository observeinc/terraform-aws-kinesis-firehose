output "firehose_delivery_stream" {
  description = "Kinesis Firehose delivery stream towards Observe"
  value       = aws_kinesis_firehose_delivery_stream.this
}

output "firehose_iam_policy" {
  description = "IAM policy to publish records to Kinesis Firehose. If a Kinesis Data Stream is set as a source, no policy is provided since Firehose will not allow any other event source."
  value       = local.enable_kinesis_source ? null : aws_iam_policy.put_record
}
