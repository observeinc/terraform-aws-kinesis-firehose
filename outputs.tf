output "firehose_delivery_stream" {
  description = "Kinesis Firehose"
  value       = aws_kinesis_firehose_delivery_stream.this
}

output "firehose_iam_policy" {
  description = "IAM policy to publish records to Kinesis Firehose"
  value       = aws_iam_policy.put_record
}
