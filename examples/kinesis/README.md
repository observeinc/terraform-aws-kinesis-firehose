# Kinesis Data Stream to Observe 

The configuration in this directory documents how to read events out of a
Kinesis Data Stream into Observe via a Kinesis Firehose delivery stream.
EventBridge is used to generate events which are written to the Kinesis Data
Stream.


## Usage

To run this example, execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this will create AWS resources - once you are done, run `terraform destroy`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.68 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.68 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_observe_kinesis"></a> [observe\_kinesis](#module\_observe\_kinesis) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.scheduled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_policy.put_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.eventbridge_kinesis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kinesis_stream.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [random_pet.run](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_observe_customer"></a> [observe\_customer](#input\_observe\_customer) | Observe Customer ID | `string` | n/a | yes |
| <a name="input_observe_token"></a> [observe\_token](#input\_observe\_token) | Observe token | `string` | n/a | yes |
| <a name="input_observe_url"></a> [observe\_url](#input\_observe\_url) | Observe URL | `string` | `"https://kinesis.collect.observeinc.com"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
