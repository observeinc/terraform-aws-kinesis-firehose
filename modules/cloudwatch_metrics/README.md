# AWS Cloudwatch Metrics to Kinesis Firehose

This module configures AWS Cloudwatch Metrics to be sent to Observe through a
Kinesis Firehose stream.

## Usage

```hcl
module "kinesis_firehose" {
  source           = "observeinc/kinesis-firehose/aws"

  name                        = var.name
  observe_collection_endpoint = "https://<id>.collect.observeinc.com"
  observe_token               = var.observe_token
}

module "cloudwatch_metrics" {
  source           = "observeinc/kinesis-firehose/aws//cloudwatch_metrics"
  kinesis_firehose = module.kinesis_firehose
}
```

You can also provide `include_filters` or `exclude_filters`, e.g:

```
module "cloudwatch_metrics" {
  source           = "observeinc/kinesis-firehose/aws//cloudwatch_metrics"
  kinesis_firehose = module.kinesis_firehose
  exclude_filters  = ["AWS/Firehose"]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.42.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_stream.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_stream) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exclude_filters"></a> [exclude\_filters](#input\_exclude\_filters) | Namespaces to exclude. Mutually exclusive with include\_filters. | `set(string)` | `[]` | no |
| <a name="input_iam_name_prefix"></a> [iam\_name\_prefix](#input\_iam\_name\_prefix) | Prefix used for all created IAM roles and policies | `string` | `"observe-cwmetricsstream-"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | ARN of IAM role to use for Cloudwatch Metrics Stream | `string` | `""` | no |
| <a name="input_include_filters"></a> [include\_filters](#input\_include\_filters) | Namespaces to include. Mutually exclusive with exclude\_filters. | `set(string)` | `[]` | no |
| <a name="input_kinesis_firehose"></a> [kinesis\_firehose](#input\_kinesis\_firehose) | Observe Kinesis Firehose module | <pre>object({<br>    firehose_delivery_stream = object({ arn = string })<br>    firehose_iam_policy      = object({ arn = string })<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of Cloudwatch Metrics Stream and CloudFormation stack | `string` | `"observe-cwmetricsstream"` | no |
| <a name="input_output_format"></a> [output\_format](#input\_output\_format) | Output format for the stream | `string` | `"json"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
