data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
}

module "observe_kinesis_firehose" {
  source = "../..//eks"

  observe_customer = var.observe_customer
  observe_token    = var.observe_token
  observe_domain   = var.observe_domain

  eks_cluster_arn         = module.eks.cluster_arn
  pod_execution_role_arns = [for group in module.eks.fargate_profiles : group.fargate_profile_pod_execution_role_arn]
  depends_on              = [module.eks]
}
