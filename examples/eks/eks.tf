module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.3.1"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  self_managed_node_group_defaults = {
    root_volume_type = "gp2"
  }

  fargate_profiles = {
    default = {
      name = "default"
      selectors = [
        {
          namespace = "kube-system"
        },
        {
          namespace = "default"
        },
        {
          namespace = "observe"
        },
      ]

      tags = {}

      timeouts = {
        create = "20m"
        delete = "20m"
      }
    }
  }
}

