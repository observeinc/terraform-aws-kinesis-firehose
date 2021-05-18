# AWS Kinesis Firehose Terraform module

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/observeinc/terraform-aws-kinesis-firehose)

Terraform module which creates a Kinesis Firehose delivery stream towards Observe.

## Terraform versions

Terraform 0.12 and newer. Submit pull-requests to `main` branch.

## Usage

```hcl
module "observe_kinesis_firehose" {
  source = "github.com/observeinc/terraform-aws-kinesis-firehose"

  name                = "observe-kinesis-firehose"
  observe_customer    = "<id>"
  observe_token       = "<token>"
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
  source = "github.com/observeinc/terraform-aws-kinesis-firehose"

  name                = "observe-kinesis-firehose"
  observe_customer    = "<id>"
  observe_token       = "<token>"
  s3_delivery_bucket  = aws_s3_bucket.bucket
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
  source = "github.com/observeinc/terraform-aws-kinesis-firehose"

  name                = "observe-kinesis-firehose"
  observe_customer    = "<id>"
  observe_token       = "<token>"
  kinesis_stream      = aws_kinesis_stream.example
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
  source = "github.com/observeinc/terraform-aws-kinesis-firehose"

  name                 = "observe-kinesis-firehose"
  observe_customer     = "<id>"
  observe_token        = "<token>"
  cloudwatch_log_group = aws_cloudwatch_log_group.group
}
```

Currently the module configures two output streams: one for S3 delivery, and another for HTTP endpoint delivery. You can disable either stream by setting `s3_delivery_cloudwatch_log_stream_name` and `http_endpoint_cloudwatch_log_stream_name` respectively to an empty string.

## Examples

* [EventBridge to Kinesis Firehose](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/examples/eventbridge)
* [Kinesis Data Stream to Kinesis Firehose](https://github.com/observeinc/terraform-aws-kinesis-firehose/tree/main/examples/kinesis)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | >= 3.15 |
| random | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.15 |
| random | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_log\_group | The CloudWatch group for logging. Providing this value enables logging. | <pre>object({<br>    name = string<br>    arn  = string<br>  })</pre> | `null` | no |
| http\_endpoint\_buffering\_interval | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. | `number` | `300` | no |
| http\_endpoint\_buffering\_size | Buffer incoming data to the specified size, in MiBs, before delivering it to the destination. | `number` | `5` | no |
| http\_endpoint\_cloudwatch\_log\_stream\_name | Log stream name for HTTP endpoint logs. If empty, log stream will be disabled | `string` | `"HttpEndpointDelivery"` | no |
| http\_endpoint\_content\_encoding | Kinesis Data Firehose uses the content encoding to compress the body of a request before sending the request to the destination. | `string` | `"GZIP"` | no |
| http\_endpoint\_name | Name of Kinesis Firehose target HTTP endpoint | `string` | `"Observe"` | no |
| http\_endpoint\_retry\_duration | The total amount of time that Kinesis Data Firehose spends on retries. This duration starts after the initial attempt to send data to the custom destination via HTTPS endpoint fails. It doesn't include the periods during which Kinesis Data Firehose waits for acknowledgment from the specified destination after each attempt. | `number` | `300` | no |
| http\_endpoint\_s3\_backup\_mode | S3 backup mode for Kinesis Firehose HTTP endpoint | `string` | `"FailedDataOnly"` | no |
| iam\_name\_prefix | Prefix used for all created IAM roles and policies | `string` | `"observe-kinesis-firehose-"` | no |
| kinesis\_stream | Kinesis Data Stream ARN to configure as source | `object({ arn = string })` | `null` | no |
| name | Name of Kinesis Firehose resource | `string` | n/a | yes |
| observe\_customer | Observe Customer ID | `string` | n/a | yes |
| observe\_token | Observe Token | `string` | n/a | yes |
| observe\_url | Observe URL | `string` | `"https://kinesis.collect.observeinc.com"` | no |
| s3\_delivery\_bucket | S3 bucket to be used as backup for message delivery | <pre>object({<br>    arn = string<br>  })</pre> | `null` | no |
| s3\_delivery\_buffer\_interval | Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination. | `number` | `300` | no |
| s3\_delivery\_buffer\_size | Buffer incoming data to the specified size, in MiBs, before delivering it to the destination. | `number` | `5` | no |
| s3\_delivery\_cloudwatch\_log\_stream\_name | Log stream name for S3 delivery logs. If empty, log stream will be disabled | `string` | `"S3Delivery"` | no |
| s3\_delivery\_compression\_format | The compression format. If no value is specified, the default is UNCOMPRESSED. | `string` | `"UNCOMPRESSED"` | no |
| s3\_delivery\_prefix | The "YYYY/MM/DD/HH" time format prefix is automatically used for delivered Amazon S3 files | `string` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| firehose\_delivery\_stream | Kinesis Firehose delivery stream towards Observe |
| firehose\_iam\_policy | IAM policy to publish records to Kinesis Firehose. If a Kinesis Data Stream is set as a source, no policy is provided since Firehose will not allow any other event source. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
