# AWS Cloudwatch Metrics to Kinesis Firehose

This module configures AWS Cloudwatch Metrics to be sent to Observe through a
Kinesis Firehose stream.

Cloudwatch Metrics Streams are a recent feature, and as such are not directly
supported in the terraform AWS provider. This module uses a CloudFormation
template to configure a Cloudwatch Metric Stream towards an existing Kinesis
Firehose.

## Terraform versions

Terraform 0.12 and newer. Submit pull-requests to `main` branch.

## Usage

```hcl
module "kinesis_firehose" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose"
  name             = var.name
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
}

module "cloudwatch_metrics" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose//cloudwatch_metrics"
  kinesis_firehose = module.kinesis_firehose
}
```

You can also provide `include_filters` or `exclude_filters`, e.g:

```
module "cloudwatch_metrics" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose//cloudwatch_metrics"
  kinesis_firehose = module.kinesis_firehose
  exclude_filters  = ["AWS/Firehose"]
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
| exclude\_filters | Namespaces to exclude. Mutually exclusive with include\_filters. | `list(string)` | `[]` | no |
| iam\_name\_prefix | Prefix used for all created IAM roles and policies | `string` | `"observe-cwmetricsstream-"` | no |
| iam\_role\_arn | ARN of IAM role to use for Cloudwatch Metrics Stream | `string` | `""` | no |
| include\_filters | Namespaces to include. Mutually exclusive with exclude\_filters. | `list(string)` | `[]` | no |
| kinesis\_firehose | Observe Kinesis Firehose module | <pre>object({<br>    firehose_delivery_stream = object({ arn = string })<br>    firehose_iam_policy      = object({ arn = string })<br>  })</pre> | n/a | yes |
| name | Name of Cloudwatch Metrics Stream and CloudFormation stack | `string` | `"observe-cwmetricsstream"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
