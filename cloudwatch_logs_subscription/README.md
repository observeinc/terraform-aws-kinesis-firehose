# Cloudwatch Logs to Kinesis Firehose

Given a list of Cloudwatch Log Group names and an Observe Kinesis Firehose module, this 
module subscribes each Log Group to the Kinesis Firehose.

Terraform 0.12 and newer. Submit pull-requests to `main` branch.

## Usage

```hcl
resource "aws_cloudwatch_log_group" "group" {
  name_prefix = random_pet.run.id
}

module "observe_kinesis_firehose" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose"
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  name             = random_pet.run.id
}

module "observe_kinesis_firehose_cloudwatch_logs_subscription" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose//cloudwatch_logs_subscription"
  kinesis_firehose = module.observe_kinesis_firehose
  log_group_names  = [
    aws_cloudwatch_log_group.group.name
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.21 |
| aws | >= 2.68 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| filter\_name | Filter name | `string` | `"observe-filter"` | no |
| filter\_pattern | The filter pattern to use. For more information, see [Filter and Pattern Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html) | `string` | `""` | no |
| kinesis\_firehose | Observe Kinesis Firehose module | <pre>object({<br>    firehose_delivery_stream = object({ arn = string })<br>    firehose_iam_policy      = object({ arn = string })<br>  })</pre> | n/a | yes |
| log\_group\_names | Cloudwatch Log Group names to subscribe to Observe Lambda | `list(string)` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
