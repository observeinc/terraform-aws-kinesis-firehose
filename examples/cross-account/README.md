# Cross Account Role for Firehose

The configuration in this directory documents how to set up a cross account role for writing to firehose.

A role is created which provides the capability of putting records to the
configured firehose delivery stream. This role can be assumed by an external
account, and is in this example tied to a specific user.

## Usage

To run this example, execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

This will set up a Firehose Delivery Stream with cross-account access for the provided user ARN.

If you would like to set up the sender side user permissions, you will need the following:

```
provider "aws" {
  profile = "other"
  alias   = "sender"
}

locals {
  user = regex("arn:aws:iam::\\d{12}:user/(?P<name>.+)", var.user_arn)
}

resource "aws_iam_policy" "user_assume_role" {
  description = "allow assuming firehose role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "sts:AssumeRole",
        Resource = "arn:aws:iam::${data.aws_caller_identity.receiver.account_id}:role/${var.name}"
    }]
  })
  provider = aws.sender
}

resource "aws_iam_user_policy_attachment" "user_assume_role" {
  user       = local.user
  policy_arn = aws_iam_policy.user_assume_role.arn
  provider   = aws.sender
}
```

Note that this will create AWS resources - once you are done, run `terraform destroy`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.9 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_observe_kinesis_firehose"></a> [observe\_kinesis\_firehose](#module\_observe\_kinesis\_firehose) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.put_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_external_ids"></a> [external\_ids](#input\_external\_ids) | External ID array | `list(string)` | `null` | no |
| <a name="input_http_endpoint_s3_backup_mode"></a> [http\_endpoint\_s3\_backup\_mode](#input\_http\_endpoint\_s3\_backup\_mode) | S3 backup mode for Kinesis Firehose HTTP endpoint. By default, only data that cannot be delivered to Observe via HTTP is written to S3. To backup all data to S3, set this to `AllData`. | `string` | `"FailedDataOnly"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for firehose and matching IAM role | `string` | n/a | yes |
| <a name="input_observe_collection_endpoint"></a> [observe\_collection\_endpoint](#input\_observe\_collection\_endpoint) | Observe Collection Endpoint, e.g https://123456789012.collect.observeinc.com | `string` | n/a | yes |
| <a name="input_observe_token"></a> [observe\_token](#input\_observe\_token) | Observe token | `string` | n/a | yes |
| <a name="input_user_arn"></a> [user\_arn](#input\_user\_arn) | ARN for external user granted access to assume role | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cross_account_role"></a> [cross\_account\_role](#output\_cross\_account\_role) | Role providing cross-account access to provided user |
| <a name="output_firehose_arn"></a> [firehose\_arn](#output\_firehose\_arn) | Configured firehose |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
