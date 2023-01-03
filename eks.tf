module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = "ava-eks-cluster"  
  cluster_version = "1.24"
  cluster_endpoint_public_access  = true


  subnet_ids = module.avaphotos-vpc.private_subnets
  vpc_id = module.avaphotos-vpc.vpc_id

  tags = {
    environment = "development"
    application = "avaphotos"
  }

  #EKS Managed Node Group(s)
  eks_managed_node_groups = {
    dev = {
      min_size     = 1
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }
}