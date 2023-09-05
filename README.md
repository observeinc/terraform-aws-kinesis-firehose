# AWS Kinesis Firehose Terraform module

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/observeinc/terraform-aws-kinesis-firehose)

Terraform module which creates a Kinesis Firehose delivery stream towards Observe.

Additionally, this repository provides submodules to interact with the Firehose delivery stream set up by this module:

* [Subscribe CloudWatch Logs to Kinesis Firehose](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/modules/cloudwatch_logs_subscription)
* [Collect CloudWatch Metrics Stream](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/modules/cloudwatch_metrics)
* [Collect EventBridge](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/modules/eventbridge)
* [Collect EKS Fargate logs](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/modules/eks)

## Usage

```hcl
module "observe_kinesis_firehose" {
  source = "observeinc/kinesis-firehose/aws"

  name                        = "observe-kinesis-firehose"
  observe_collection_endpoint = "https://<id>.collect.observeinc.com"
  observe_token               = var.observe_token
}
```

This module will create a Kinesis Firehose delivery stream, as well as a role
and any required policies. An S3 bucket will be created to store messages that
failed to be delivered to Observe.

## Providing an S3 bucket

If you prefer providing an existing S3 bucket, you can pass it as a module parameter:

```hcl
resource "aws_s3_bucket" "bucket" {
  bucket        = "observe-kinesis-firehose-bucket"
  acl           = "private"
  force_destroy = true
}

module "observe_kinesis_firehose" {
  source = "observeinc/kinesis-firehose/aws"

  name                        = "observe-kinesis-firehose"
  observe_collection_endpoint = "https://<id>.collect.observeinc.com"
  observe_token               = var.observe_token
  s3_delivery_bucket          = aws_s3_bucket.bucket
}
```

## Configuring Kinesis Data Stream as a source

You can specify a Kinesis Data Stream to act as a source to the Kinesis Firehose delivery stream. Only one data stream can be specified, and configuring this option disables all other inputs to your Kinesis Firehose.

```hcl
resource "aws_kinesis_stream" "example" {
  name             = "observe-kinesis-stream-example"
  shard_count      = 1
  retention_period = 24
}

module "observe_kinesis_firehose" {
  source = "observeinc/kinesis-firehose/aws"

  name                        = "observe-kinesis-firehose"
  observe_collection_endpoint = "https://<id>.collect.observeinc.com"
  observe_token               = "<token>"
  kinesis_stream              = aws_kinesis_stream.example
}
```

For more details, see the Kinesis Data Stream example.

## Configuring other sources

If you have not specified a Kinesis Data Stream as a source, you are free to configure other sources to send directly to your Kinesis Firehose delivery stream. You can use the module output policy when adding sources:

```hcl
resource "aws_iam_role_policy_attachment" "invoke_firehose" {
  role       = aws_iam_role.role.name
  policy_arn = module.observe_kinesis_firehose.firehose_iam_policy.arn
}
```

See the provided EventBridge example for a more complete example.

## Cloudwatch Logs

A Cloudwatch Log Group can optionally be provided in order to surface logs for
both S3 and HTTP endpoint delivery.

```hcl
resource "aws_cloudwatch_log_group" "group" {
  name              = "my-log-group"
  retention_in_days = 14
}

module "observe_kinesis_firehose" {
  source = "observeinc/kinesis-firehose/aws"

  name                        = "observe-kinesis-firehose"
  observe_collection_endpoint = "https://<id>.collect.observeinc.com"
  observe_token               = "<token>"
  cloudwatch_log_group        = aws_cloudwatch_log_group.group
}
```

Currently the module configures two output streams: one for S3 delivery, and another for HTTP endpoint delivery. You can disable either stream by setting `s3_delivery_cloudwatch_log_stream_name` and `http_endpoint_cloudwatch_log_stream_name` respectively to an empty string.

## Examples

This repository contains examples of how to solve for concrete usecases:

* [EventBridge to Kinesis Firehose](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/examples/eventbridge)
* [Kinesis Data Stream to Kinesis Firehose](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/examples/kinesis)
* [Cross Account Role for Firehose](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/examples/cross-account)
* [EKS to Observe](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/examples/eks)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.75, <5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.75, <5.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_stream.http_endpoint_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_cloudwatch_log_stream.s3_delivery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_iam_policy.firehose_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.firehose_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.kinesis_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.put_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.firehose_cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.firehose_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kinesis_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_firehose_delivery_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [random_string.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#input\_cloudwatch\_log\_group) | The CloudWatch group for logging. Providing this value enables logging. | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | `null` | no |
| <a name="input_common_attributes"></a> [common\_attributes](#input\_common\_attributes) | Key value pairs sent as payload metadata | `map(string)` | `{}` | no |
| <a name="input_http_endpoint_buffering_interval"></a> [http\_endpoint\_buffering\_interval](#input\_http\_endpoint\_buffering\_interval) | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. | `number` | `60` | no |
| <a name="input_http_endpoint_buffering_size"></a> [http\_endpoint\_buffering\_size](#input\_http\_endpoint\_buffering\_size) | Buffer incoming data to the specified size, in MiBs, before delivering it to the destination. | `number` | `1` | no |
| <a name="input_http_endpoint_cloudwatch_log_stream_name"></a> [http\_endpoint\_cloudwatch\_log\_stream\_name](#input\_http\_endpoint\_cloudwatch\_log\_stream\_name) | Log stream name for HTTP endpoint logs. If empty, log stream will be disabled | `string` | `"HttpEndpointDelivery"` | no |
| <a name="input_http_endpoint_content_encoding"></a> [http\_endpoint\_content\_encoding](#input\_http\_endpoint\_content\_encoding) | Kinesis Data Firehose uses the content encoding to compress the body of a request before sending the request to the destination. | `string` | `"GZIP"` | no |
| <a name="input_http_endpoint_name"></a> [http\_endpoint\_name](#input\_http\_endpoint\_name) | Name of Kinesis Firehose target HTTP endpoint | `string` | `"Observe"` | no |
| <a name="input_http_endpoint_retry_duration"></a> [http\_endpoint\_retry\_duration](#input\_http\_endpoint\_retry\_duration) | The total amount of time that Kinesis Data Firehose spends on retries. This duration starts after the initial attempt to send data to the custom destination via HTTPS endpoint fails. It doesn't include the periods during which Kinesis Data Firehose waits for acknowledgment from the specified destination after each attempt. | `number` | `300` | no |
| <a name="input_http_endpoint_s3_backup_mode"></a> [http\_endpoint\_s3\_backup\_mode](#input\_http\_endpoint\_s3\_backup\_mode) | S3 backup mode for Kinesis Firehose HTTP endpoint. By default, only data that cannot be delivered to Observe via HTTP is written to S3. To backup all data to S3, set this to `AllData`. | `string` | `"FailedDataOnly"` | no |
| <a name="input_iam_name_prefix"></a> [iam\_name\_prefix](#input\_iam\_name\_prefix) | Prefix used for all created IAM roles and policies | `string` | `"observe-kinesis-firehose-"` | no |
| <a name="input_kinesis_stream"></a> [kinesis\_stream](#input\_kinesis\_stream) | Kinesis Data Stream ARN to configure as source | `object({ arn = string })` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Kinesis Firehose resource | `string` | n/a | yes |
| <a name="input_observe_collection_endpoint"></a> [observe\_collection\_endpoint](#input\_observe\_collection\_endpoint) | Observe Collection Endpoint, e.g https://123456789012.collect.observeinc.com | `string` | `null` | no |
| <a name="input_observe_customer"></a> [observe\_customer](#input\_observe\_customer) | Observe Customer ID. Deprecated, please use observe\_collection\_endpoint instead | `string` | `null` | no |
| <a name="input_observe_domain"></a> [observe\_domain](#input\_observe\_domain) | Observe domain. Deprecated, please use observe\_collection\_endpoint instead | `string` | `"observeinc.com"` | no |
| <a name="input_observe_token"></a> [observe\_token](#input\_observe\_token) | Observe Token | `string` | n/a | yes |
| <a name="input_observe_url"></a> [observe\_url](#input\_observe\_url) | Observe URL. Deprecated. | `string` | `""` | no |
| <a name="input_s3_delivery_bucket"></a> [s3\_delivery\_bucket](#input\_s3\_delivery\_bucket) | S3 bucket to be used as backup for message delivery | <pre>object({<br>    arn = string<br>  })</pre> | `null` | no |
| <a name="input_s3_delivery_buffer_interval"></a> [s3\_delivery\_buffer\_interval](#input\_s3\_delivery\_buffer\_interval) | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. | `number` | `300` | no |
| <a name="input_s3_delivery_buffer_size"></a> [s3\_delivery\_buffer\_size](#input\_s3\_delivery\_buffer\_size) | Buffer incoming data to the specified size, in MiBs, before delivering it to the destination. | `number` | `5` | no |
| <a name="input_s3_delivery_cloudwatch_log_stream_name"></a> [s3\_delivery\_cloudwatch\_log\_stream\_name](#input\_s3\_delivery\_cloudwatch\_log\_stream\_name) | Log stream name for S3 delivery logs. If empty, log stream will be disabled | `string` | `"S3Delivery"` | no |
| <a name="input_s3_delivery_compression_format"></a> [s3\_delivery\_compression\_format](#input\_s3\_delivery\_compression\_format) | The compression format. If no value is specified, the default is UNCOMPRESSED. | `string` | `"UNCOMPRESSED"` | no |
| <a name="input_s3_delivery_prefix"></a> [s3\_delivery\_prefix](#input\_s3\_delivery\_prefix) | The "YYYY/MM/DD/HH" time format prefix is automatically used for delivered Amazon S3 files | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firehose_delivery_stream"></a> [firehose\_delivery\_stream](#output\_firehose\_delivery\_stream) | Kinesis Firehose delivery stream towards Observe |
| <a name="output_firehose_iam_policy"></a> [firehose\_iam\_policy](#output\_firehose\_iam\_policy) | IAM policy to publish records to Kinesis Firehose. If a Kinesis Data Stream is set as a source, no policy is provided since Firehose will not allow any other event source. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
