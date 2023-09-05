# AWS EKS Fargate logs to Kinesis Firehose

Terraform module which sets up a Kinesis Firehose delivery stream as a target for EKS Fargate logs. This codifies the process detailed in the official [fargate logging documentation](https://docs.aws.amazon.com/eks/latest/userguide/fargate-logging.html).

You will need to provide:
a) an EKS cluster ARN
b) Observe credentials
c) all pod execution roles used by the Fargate profiles in that cluster

The module performs the following:

1) given the EKS cluster ARN (a), generate an access token towards the Kubernetes
   cluster and read the UID of the `default` namespace, which we will use to
   identify the source of Fargate logs.
2) given Observe credentials (b) and `clusterUid` (1), create a Kinesis Firehose
   delivery stream which is configured to tag all outbound data towards Observe
   with a cluster identifier.
3) given the Kinesis Firehose delivery stream (2) and the pod execution roles (c),
   attach a policy to each role which allows Fargate nodes to write to the
   delivery stream.
4) given the cluster name (a), create the `aws-observability` namespace with a
   `observeinc.com/cluster-name` annotation which references the cluster ARN.
5) given the Kinesis Firehose delivery stream (2) and `aws-observability`
   namespace (5), create the `aws-logging` configMap which contains the fluent-bit
   configuration necessary to forward logs towards Observe.

After applying this module, you can proceed with the standard process for
kubernetes installation in your EKS cluster.

## Terraform versions

Terraform 0.13 and newer. Submit pull-requests to `main` branch.

## Usage

```hcl
module "observe_kinesis_firehose" {
  source = "github.com/observeinc/terraform-aws-kinesis-firehose//eks?ref=main"

  observe_collection_endpoint = "https://<id>.collect.observeinc.com"
  observe_token               = var.observe_token

  eks_cluster_arn = "arn:aws:eks:us-east-1:123456789012:cluster/cluster-name"
  pod_execution_role_arns = [
    "arn:aws:iam::123456789012:role/my-example-cluster-FargatePodExecutionRole-K3ZLJXIIXQGE",
    "arn:aws:iam::123456789012:role/my-example-cluster-FargatePodExecutionRole-AE134MASIOL4",
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.15, < 4.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.15, < 4.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_observe_kinesis"></a> [observe\_kinesis](#module\_observe\_kinesis) | ../.. | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_role_policy_attachment.firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [kubernetes_config_map_v1.aws_logging](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_namespace_v1.aws_observability](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [kubernetes_namespace_v1.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/data-sources/namespace_v1) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_arn"></a> [eks\_cluster\_arn](#input\_eks\_cluster\_arn) | EKS cluster ARN | `string` | n/a | yes |
| <a name="input_observe_collection_endpoint"></a> [observe\_collection\_endpoint](#input\_observe\_collection\_endpoint) | Observe Collection Endpoint, e.g https://123456789012.collect.observeinc.com | `string` | `null` | no |
| <a name="input_observe_customer"></a> [observe\_customer](#input\_observe\_customer) | Observe Customer ID. Deprecated, please use observe\_collection\_endpoint instead | `string` | `null` | no |
| <a name="input_observe_domain"></a> [observe\_domain](#input\_observe\_domain) | Observe domain. Deprecated, please use observe\_collection\_endpoint instead | `string` | `null` | no |
| <a name="input_observe_token"></a> [observe\_token](#input\_observe\_token) | Observe Token | `string` | n/a | yes |
| <a name="input_pod_execution_role_arns"></a> [pod\_execution\_role\_arns](#input\_pod\_execution\_role\_arns) | List of pod execution roles tied to Fargate profiles. | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See LICENSE for full details.
