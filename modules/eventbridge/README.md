# AWS Eventbridge to Kinesis Firehose

Terraform module which sets up a Kinesis Firehose delivery stream as a target for Eventbridge Events

## Terraform versions

Terraform 0.12 and newer. Submit pull-requests to `main` branch.

## Usage

```hcl
data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_event_rule" "wildcard" {
  name        = "wildcard"
  description = "Capture all events in account"
  event_pattern = jsonencode({
    "account" : [data.aws_caller_identity.current.account_id]
  })
}

module "observe_kinesis_firehose" {
  source = "github.com/observeinc/terraform-aws-kinesis-firehose?ref=main"

  name             = "observe-kinesis-firehose"
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
}

module "observe_firehose_eventbridge" {
  source           = "github.com/observeinc/terraform-aws-kinesis-firehose//eventbridge"
  kinesis_firehose = module.observe_kinesis_firehose
  iam_name_prefix  = var.name
  rules = [
    aws_cloudwatch_event_rule.wildcard,
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.15 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_target.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_name_prefix"></a> [iam\_name\_prefix](#input\_iam\_name\_prefix) | Prefix used for all created IAM roles and policies | `string` | `"observe-kinesis-firehose-"` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | ARN of IAM role to use for EventBridge target | `string` | `""` | no |
| <a name="input_kinesis_firehose"></a> [kinesis\_firehose](#input\_kinesis\_firehose) | Observe Kinesis Firehose module | <pre>object({<br>    firehose_delivery_stream = object({ arn = string })<br>    firehose_iam_policy      = object({ arn = string })<br>  })</pre> | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | List of EventBridge rules to subscribe to Firehose | `list(object({ name = string }))` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
