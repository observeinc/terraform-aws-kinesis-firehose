# EventBridge to Observe 

The configuration in this directory documents how to send EventBridge (formerly Cloudwatch Events) events to Observe via a Kinesis Firehose delivery stream.

A single EventBridge rule is configured, which will create an event every minute. These events are sent to a Kinesis Firehose target, which in turn is configured to submit events to Observe over HTTPS.

We additionally create an S3 bucket and a Cloudwatch Log Group for use with our Kinesis Firehose target.

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
| terraform | >= 0.12.21 |
| aws | >= 2.68 |
| random | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.68 |
| random | >= 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| observe\_customer | Observe Customer ID | `string` | n/a | yes |
| observe\_token | Observe token | `string` | n/a | yes |
| observe\_url | Observe URL | `string` | `"https://kinesis.collect.observeinc.com"` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
