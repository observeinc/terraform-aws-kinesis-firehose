locals {
  role_regex               = "arn:aws:iam::\\d{12}:role/(?P<name>.+)"
  name_regex               = "arn:aws:eks:[^:]+:\\d{12}:cluster/(?P<name>.+)"
  pod_execution_role_names = [for i in var.pod_execution_role_arns : regex(local.role_regex, i)["name"]]
  eks_cluster_name         = regex(local.name_regex, var.eks_cluster_arn)["name"]
}

data "aws_region" "current" {}

data "kubernetes_namespace_v1" "default" {
  metadata {
    name = "default"
  }
}

resource "kubernetes_namespace_v1" "aws_observability" {
  metadata {
    annotations = {
      "observeinc.com/cluster-name" = var.eks_cluster_arn
    }

    labels = {
      aws-observability = "enabled"
    }

    name = "aws-observability"
  }
}

module "observe_kinesis" {
  source = "./.."

  name             = format("observe-eks-%s", local.eks_cluster_name)
  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_url      = format("https://kinesis.collect.%s", var.observe_domain)
  common_attributes = {
    clusterUid = data.kubernetes_namespace_v1.default.metadata[0].uid
  }
}

resource "aws_iam_role_policy_attachment" "firehose" {
  count      = length(local.pod_execution_role_names)
  role       = local.pod_execution_role_names[count.index]
  policy_arn = module.observe_kinesis.firehose_iam_policy.arn
}

resource "kubernetes_config_map_v1" "aws_logging" {
  metadata {
    name      = "aws-logging"
    namespace = "aws-observability"
  }
  data = {
    "filters.conf" = <<-EOF
      [FILTER]
        Name                kubernetes
        Match               kube.*
        Merge_Log           Off
        Buffer_Size         0
        Kube_Meta_Cache_TTL 300s
        Labels              Off
        Annotations         Off
    EOF
    "output.conf"  = <<-EOF
      [OUTPUT]
        Name kinesis_firehose
        Match *
        Region ${data.aws_region.current.name}
        Delivery_Stream ${module.observe_kinesis.firehose_delivery_stream.name}
    EOF
  }
}
