# Cloudwatch Logs to Kinesis Firehose

Given a list of Cloudwatch Log Group names and an Observe Kinesis Firehose module, this 
module subscribes each Log Group to the Kinesis Firehose.

## Usage

```hcl
resource "aws_cloudwatch_log_group" "group" {
  name_prefix = random_pet.run.id
}

module "observe_kinesis_firehose" {
  source           = "observeinc/kinesis-firehose/aws"
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  name             = random_pet.run.id
}

module "observe_kinesis_firehose_cloudwatch_logs_subscription" {
  source           = "observeinc/kinesis-firehose/aws//modules/cloudwatch_logs_subscription"
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.68 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.68 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.subscription_filter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_filter_name"></a> [filter\_name](#input\_filter\_name) | Filter name | `string` | `"observe-filter"` | no |
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | The filter pattern to use. For more information, see [Filter and Pattern Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html) | `string` | `""` | no |
| <a name="input_iam_name_prefix"></a> [iam\_name\_prefix](#input\_iam\_name\_prefix) | Prefix used for all created IAM roles and policies | `string` | `"observe-kinesis-firehose-"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | ARN of IAM role to use for Cloudwatch Logs subscription | `string` | `""` | no |
| <a name="input_kinesis_firehose"></a> [kinesis\_firehose](#input\_kinesis\_firehose) | Observe Kinesis Firehose module | <pre>object({<br>    firehose_delivery_stream = object({ arn = string })<br>    firehose_iam_policy      = object({ arn = string })<br>  })</pre> | n/a | yes |
| <a name="input_log_group_names"></a> [log\_group\_names](#input\_log\_group\_names) | Cloudwatch Log Group names to subscribe to Observe Lambda | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
