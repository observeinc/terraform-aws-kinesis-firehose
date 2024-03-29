locals {
  cluster_name = var.cluster_name != null ? var.cluster_name : random_pet.run.id
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "random_pet" "run" {}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

module "observe_kinesis_firehose" {
  source = "../../modules/eks"

  observe_collection_endpoint = var.observe_collection_endpoint
  observe_token               = var.observe_token

  eks_cluster_arn         = module.eks.cluster_arn
  pod_execution_role_arns = [for group in module.eks.fargate_profiles : group.fargate_profile_pod_execution_role_arn]
  depends_on              = [module.eks]
}
