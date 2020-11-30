# Kinesis Data Strem to Observe 

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
